require 'net/http'
require 'uri'

class QueriesController < ApplicationController
  # GET /queries
  # GET /queries.xml
  def index
    @queries = Query.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @queries }
    end
  end

  # GET /queries/1
  # GET /queries/1.xml
  def show
    @query = Query.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @query }
    end
  end

  # GET /queries/new
  # GET /queries/new.xml
  def new
    @query = Query.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @query }
    end
  end

  # GET /queries/1/edit
  def edit
    @query = Query.find(params[:id])
  end

  # POST /queries
  # POST /queries.xml
  def create
    @query = Query.new(params[:query])

    respond_to do |format|
      if @query.save
        format.html { redirect_to(@query, :notice => 'Query was successfully created.') }
        format.xml  { render :xml => @query, :status => :created, :location => @query }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @query.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /queries/1
  # PUT /queries/1.xml
  def update
    @query = Query.find(params[:id])

    respond_to do |format|
      if @query.update_attributes(params[:query])
        format.html { redirect_to(@query, :notice => 'Query was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @query.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /queries/1
  # DELETE /queries/1.xml
  def destroy
    @query = Query.find(params[:id])
    @query.destroy

    respond_to do |format|
      format.html { redirect_to(queries_url) }
      format.xml  { head :ok }
    end
  end

  def run
    @query = Query.find(params[:id])
    sparql = <<-EOH
PREFIX rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>
PREFIX xsd:   <http://www.w3.org/2001/XMLSchema#>
PREFIX owl:   <http://www.w3.org/2002/07/owl#>
PREFIX swrl:  <http://www.w3.org/2003/11/swrl#>
PREFIX swrlb: <http://www.w3.org/2003/11/swrlb#>
PREFIX vitro: <http://vitro.mannlib.cornell.edu/ns/vitro/0.7#>
PREFIX bibo: <http://purl.org/ontology/bibo/>
PREFIX dcelem: <http://purl.org/dc/elements/1.1/>
PREFIX dcterms: <http://purl.org/dc/terms/>
PREFIX event: <http://purl.org/NET/c4dm/event.owl#>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX geo: <http://aims.fao.org/aos/geopolitical.owl#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX ufVivo: <http://vivo.ufl.edu/ontology/vivo-ufl/>
PREFIX core: <http://vivoweb.org/ontology/core#>

EOH
    sparql += @query.content
    sparql = URI.escape(sparql)
    output = URI.escape("text")
    @results = Net::HTTP.get('dev.vivo.ufl.edu', "/joseki/#{params[:db]}?query=#{sparql}&output=#{output}")
    logger.info(@results)
  end
    
end
