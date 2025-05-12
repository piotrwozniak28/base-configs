```bash
terragrunt graph-dependencies &> terragrunt-graph-dependencies.tmp


dot -Tsvg \
    -Nshape=rect \
    -Gsplines=ortho \
    -Granksep=1.5 \
    -Gnodesep=0.8 \
    -Nstyle=filled \
    -Nfillcolor="#E8F4F8" \
    -Ncolor="#1696d2" \
    -Ecolor="#666666" \
    -Gfontname="Helvetica" \
    -Nfontname="Helvetica" \
    -Efontname="Helvetica" \
    < terragrunt-graph-dependencies.tmp > tmp2.svg



dot -Tsvg \
    -Nshape=rect \
    -Gsplines=ortho \
    -Granksep=1.5 \
    -Gnodesep=0.8 \
    -Nstyle=filled \
    -Nfillcolor="#E8F4F8" \
    -Ncolor="#1696d2" \
    -Ecolor="#666666" \
    -Gfontname="Helvetica" \
    -Nfontname="Helvetica" \
    -Efontname="Helvetica" \
    -Grankdir=TB \
    < terragrunt-graph-dependencies.tmp > tmp3.svg

dot -Tsvg \
    -Nshape=rect \
    -Gsplines=ortho \
    -Granksep=1.5 \
    -Gnodesep=0.8 \
    -Nstyle=filled \
    -Nfillcolor="#E8F4F8" \
    -Ncolor="#1696d2" \
    -Ecolor="#666666" \
    -Gfontname="Helvetica" \
    -Nfontname="Helvetica" \
    -Efontname="Helvetica" \
    -Grankdir=TB \
    -Gconcentrate=true \
    < terragrunt-graph-dependencies.tmp > tmp4.svg


dot -Tsvg \
    -Nshape=rect \
    -Gsplines=ortho \
    -Granksep=1.5 \
    -Gnodesep=0.8 \
    -Nstyle=filled \
    -Nfillcolor="#E8F4F8" \
    -Ncolor="#1696d2" \
    -Ecolor="#666666" \
    -Gfontname="Helvetica" \
    -Nfontname="Helvetica" \
    -Efontname="Helvetica" \
    -Grankdir=TB \
    -Gconcentrate=true \
    -Gcompound=true \
    < terragrunt-graph-dependencies.tmp > tmp5.svg






# For vertical orientation (top to bottom)
-Grankdir=TB

# For tighter clustering
-Gconcentrate=true

# For more compact layout
-Gcompound=true



dot -Tsvg \
    -Nshape=record \
    -Gsplines=polyline \
    -Granksep=2.0 \
    -Gnodesep=1.0 \
    -Nstyle="filled,rounded" \
    -Nfillcolor="#f0f9ff" \
    -Ncolor="#0369a1" \
    -Ecolor="#94a3b8" \
    -Npenwidth=2 \
    -Epenwidth=1.5 \
    -Gfontname="Arial" \
    -Nfontname="Arial-Bold" \
    -Efontname="Arial" \
    -Grankdir=TB \
    -Gconcentrate=true \
    -Gcompound=true \
    -Gpack=true \
    -Goverlap=false \
    -Gclusterrank=local \
    -Gmindist=2.0 \
    < terragrunt-graph-dependencies.tmp > tmp6.svg


dot -Tsvg \
    -Nshape=record \
    -Gsplines=polyline \
    -Granksep=2.0 \
    -Gnodesep=1.0 \
    -Nstyle="filled,rounded" \
    -Nfillcolor="#f0f9ff" \
    -Ncolor="#0369a1" \
    -Ecolor="#94a3b8" \
    -Npenwidth=2 \
    -Epenwidth=1.5 \
    -Gfontname="Arial" \
    -Nfontname="Arial-Bold" \
    -Efontname="Arial" \
    -Grankdir=TB \
    -Gconcentrate=true \
    -Gcompound=true \
    -Gpack=true \
    -Goverlap=false \
    -Gclusterrank=local \
    -Gmindist=2.0 \
    -Gminlen=1 \
    -Gmaxiter=1000 \
    -Gweight=2 \
    < terragrunt-graph-dependencies.tmp > tmp7.svg
```