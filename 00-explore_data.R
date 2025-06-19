library(tidyverse)
library(network)
library(ergm)


## links: 
link_alter <- read_csv("data/raw/Original Datase_linkAlter_All observations.csv")
alter <- read_csv("data/raw/Original Dataset_Alter_All observations.csv")
ego <- read_csv("data/raw/Original Dataset_Ego_All observations.csv")
mat <- read_csv("data/raw/Original dataset_EGO_ALTER_CLEANED_ONLY PEER.csv")

# rename:
names(link_alter) <- names(link_alter) |> 
    str_remove_all("networkcanvas") |> 
    str_replace(pattern = "uu", replacement =  "_") 

link_alter <- link_alter |> rename(uu_id = `_id`)

net <- link_alter |> # 3410
    select(source_id, target_id) |> 
    bind_rows(link_alter |> select(source_id = ego_id, target_id = source_id) |>
                  unique() ) |> #3950
    bind_rows(link_alter |> select(source_id = ego_id, target_id) |> unique()) |> # 4490
    unique() |> # 3975
    network(directed = TRUE, matrix.type = "edgelist", ignore.eval = TRUE)


ego |> names()
ego |> str()
alter |> names()

names(mat)

net_farms <- mat |> 
    select(id_farm_ego = farmlo1,id_farm_alter = mapalter) |> 
    unique() |> 
    filter(!is.na(id_farm_alter)) |> 
    filter(id_farm_ego != id_farm_alter) |> 
    network(directed = TRUE, matrix.type = "edgelist", ignore.eval = TRUE)

net_farmers <-  mat |> 
    select(ego_id = idencuesta, alter_id = idal) |> 
    filter(!is.na(alter_id)) |> 
    network(directed = TRUE, matrix.type = "edgelist", ignore.eval = TRUE)

plot.network(net_farms)



## network: 247 duplicates
net <- network(
    link_alter |> select(ego_id, "_id") |> unique(),
    directed = TRUE, matrix.type = "edgelist", ignore.eval = TRUE
)

plot.network(
    net, displayisolates = TRUE, edge.col = alpha("grey50", alpha = 0.4), vertex.col = "orange",
    vertex.border = 0, edge.lwd = 0.01)
