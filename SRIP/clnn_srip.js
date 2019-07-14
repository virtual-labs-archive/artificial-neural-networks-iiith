let T = 100;
let pi = 3.14159;
let sig0 = 1;
let sigT = sig0;
let tou1 = T;
let eta0 = 0.05;
let etaT = eta0;
let tou2 = T;
let currentIter = 0;
let iterStepSize = 3;
let flag = true;
let expdata = [];
expdata[0]=[];
expdata[1]=[];
//let yc=[];
let L = 6;
let K = 36;
let weights = [];
//let weightsyc=[];
let numPoints = 1000;
let indx = [];
//let indy=[];
let wtemp = [];
wtemp[0] = [];
wtemp[1] = [];
//let exfflag=true;
let dist = [];
dist[0] = [];
dist[1] = [];
let sumdist = [];
let mindist = 10.0;
let mindistind;
let ri = [];
ri[0] = [];
ri[1] = [];
let rnd = [];
let wdist = [];
wdist[0] = [];
wdist[1] = [];
let wdistSqr = [];
let neighInd = [];
let numofneigh = 0;
function divMax() {
    let max = -10.0;
    for (let i = 0; i < numPoints; i++) {
        if (expdata[0][i] > max) {
            max = expdata[0][i];
        }
        if (expdata[1][i] > max) {
            max = expdata[1][i];
        }
    }
    for (i = 0; i < numPoints; i++) {
        expdata[0][i] = expdata[0][i] / max;
        expdata[1][i] = expdata[1][i] / max;
    }

}

function setSquareData() {
    for (let i = 0; i < 2; i++) {
        expdata[i] = [];
        for (let j = 0; j < numPoints; j++) {
            expdata[i][j] = Math.random();
        }
    }
    divMax();
}

function setCircleData() {
    let trycirc=[];
    let d=[];
    let k=0;
    for (let i = 0; i < 2; i++) {
        trycirc[i] = [];
        for (let j = 0; j < numPoints; j++) {
            trycirc[i][j] = Math.random();
        }
    }
    for(let i=0;i<numPoints;i++)
    {
        d[i]=(trycirc[0][i]-0.5)*(trycirc[0][i]-0.5) + (trycirc[1][i]-0.5)*(trycirc[1][i]-0.5);
        d[i]=Math.sqrt(d[i]);
        if(d[i]<=0.5)
        {
            expdata[0][k]=trycirc[0][i];
            expdata[1][k]=trycirc[1][i];
            k++;
            //console.log(k);
        }
    }
    numPoints=k;

    //console.log(numPoints);
    divMax();
}

function setTriangleData() {
    let ii,jj,kk;
    for(let i=0;i<numPoints;)
    {
        ii=Math.random();
        jj=Math.random();
        if(ii+jj<1)
        {
            kk=1.0-ii-jj;
            expdata[0][i]=jj + 0.5*kk;
            expdata[1][i]=0.86603 * kk;
            i++;
        }
    }    
    divMax();
}

function setData(choice) {
    if(choice=="square")
    {
        setSquareData();
    }
    else if(choice=="circle")
    {
        setCircleData();
    }
    else if(choice=="triangle")
    {
        setTriangleData();
    }
}



function plotDataDist() {
    //console.log("reached here");
    //console.log(data[0]);
    //console.log(data[1]);
    let drawdata = {
        x: expdata[0],
        y: expdata[1],
        mode: 'markers',
        type: 'scatter',
        hoverinfo:'skip',
        marker: {
            size: 14,
            symbol: "circle-open",
            color: "brown"
        }
    };
    let layout = {
        xaxis: {
            range: [-0.1, 1.1],
            title: "X-coordinate of data"
        },
        yaxis: {
            range: [-0.1, 1.1],
            title: "Y-coordinate of data"
        },
        title: "Data Distribution",
        width: 600,
        height: 600

        //xlabel:"X-coordinate of data",
        //ylabel:"Y-coordinate of data"
    };

    var data = [drawdata];

    Plotly.newPlot('data-distribution', data, layout);
}

function setWeights() {
    for (let i = 0; i < 2; i++) {
        weights[i] = [];
        for (let j = 0; j < K; j++) {
            weights[i][j] = Math.random();
        }
    }
}

function setIndices() {
    indx[0] = [];
    indx[1] = [];
    let k1 = 0, k2 = 1;
    for (let i = 0; i < K; i++) {
        if (i % L == 0) {
            k1++;
            k2 = 1;
        }
        indx[0][i] = k2;
        indx[1][i] = k1;
        k2++;
    }
    //console.log(indx);
    //console.log(indy);
}

function plotWeightDist() {
    
    let drawWeights = {
        x: wtemp[0],
        y: wtemp[1],
        mode: 'lines+markers',
        type: 'scatter',
        hoverinfo:'skip',
        showlegend: false,
        marker: {
            size: 14,
            symbol: "circle-x",
            color: "brown"
        },
        line: {
            color: "blue",
            width: 1
        }
    };
    let layout = {
        xaxis: {
            range: [-0.1, 1.1],
            title: "X-coordinate of data"
        },
        yaxis: {
            range: [-0.1, 1.1],
            title: "Y-coordinate of data"
        },
        title: "Data Distribution",
        width: 600,
        height: 600
    };
    let data = [drawWeights];
    //if (flag) {
    //    flag = false;
        Plotly.newPlot('weight-distribution', data, layout);
        //console.log("once");
    //}
    /*else {
        Plotly.addTraces(
            'weight-distribution',
            {
                x: [wtemp[0][0], wtemp[0][1]],
                y: [wtemp[1][0], wtemp[1][1]],
                mode: 'lines+markers',
                type: 'scatter',
                hoverinfo:'skip',
                showlegend: false,
                marker: {
                    size: 14,
                    symbol: "circle-x",
                    color: "brown"
                },
                line: {
                    color: "blue",
                    width: 1
                }
            });
        //console.log("again");
    }*/

}

function calcWeightDist() {
    let countl=0;
    //console.log(weights[0]);
    //console.log(weights[1]);

    for (let k = 0; k < K; k++) {
        for (let i = 0; i < K; i++) {
            wdist[0][i] = indx[0][i] - indx[0][k];
            wdist[1][i] = indx[1][i] - indx[1][k];
            wdistSqr[i] = wdist[0][i] * wdist[0][i] + wdist[1][i] * wdist[1][i];
            if (wdistSqr[i] == 1) {
                neighInd[numofneigh] = i;
                numofneigh++;
            }

        }
        //console.log(neighInd[0] + "," + neighInd[1]);
        for (let i = 0; i < numofneigh; i++) {
            wtemp[0][countl] = weights[0][k];
            wtemp[1][countl] = weights[1][k];
            wtemp[0][countl+1] = weights[0][neighInd[i]];
            wtemp[1][countl+1] = weights[1][neighInd[i]];
            countl+=2;
            wtemp[0][countl] = {NaN};
            wtemp[1][countl] = {NaN};
            countl++;
            //console.log(wtemp[0][0] + "," + wtemp[1][0]);
            //console.log(wtemp[0][1] + "," + wtemp[1][1]);
            //console.log("break");

        }
        //console.log(numofneigh);
        numofneigh = 0;

    }
    plotWeightDist();



}

function generateData() {
    let region=document.getElementById("region").value;
    setData(region);
    plotDataDist();
    setWeights();
    setIndices();
    calcWeightDist();
}
/*
function updateIterValues() {
    if (currentIter < iterStepSize && iterStepSize <= T) {
        return true;
    }
    else {
        if (currentIter >= iterStepSize) {
            iterStepSize += 10;
            return false;
        }
        if (iterStepSize > T) {
            return false;
        }
    }
}*/

function nextIteration() {
    for(;currentIter<1;currentIter++) {
        
        for (let i = 0; i < numPoints; i++) {
            rnd[i] = parseInt((Math.random() * numPoints));
        }
        //console.log(rnd);
        for (let p = 0; p < numPoints; p++) {
            let j = rnd[p];
            for (let i = 0; i < K; i++) {
                dist[0][i] = weights[0][i] - expdata[0][j];
                dist[1][i] = weights[1][i] - expdata[1][j];
                sumdist[i] = dist[0][i]*dist[0][i] + dist[1][i]*dist[1][i];
                //console.log(sumdist[i]);
                if (sumdist[i] < mindist) {
                    mindist = sumdist[i];
                    mindistind = i;
                }
            }
 //           console.log(mindist);
            for (let i = 0; i < K; i++) {
                ri[0][i] = indx[0][mindistind];
                ri[1][i] = indx[1][mindistind];
                sumdist[i] = (indx[0][i] - ri[0][i]) * (indx[0][i] - ri[0][i]) + (indx[1][i] - ri[1][i]) * (indx[1][i] - ri[1][i]);
                sumdist[i] = sumdist[i] / (-2 * sigT);
                sumdist[i] = Math.exp(sumdist[i]);
                sumdist[i] = (etaT / (Math.sqrt(2 * pi) * sigT)) * sumdist[i];
                let temp1 = (sumdist[i]) * (expdata[0][j] - weights[0][i]);
                let temp2 = (sumdist[i]) * (expdata[1][j] - weights[1][i]);
                weights[0][i] += temp1;
                weights[1][i] += temp2;
            }
            mindist=10.0;
        }
        sigT = sig0*Math.exp(-(currentIter+1)/tou1);
        etaT = eta0*Math.exp(-(currentIter+1)/tou2);
        
    }
    currentIter=0;
    flag=true;
    calcWeightDist();
}








