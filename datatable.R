rm(list = ls())
gc()


library(data.table)

# Load data
start = Sys.time()
data = fread("./data_28.csv")
stop = Sys.time()

print(paste0("Time: ", stop - start))


# Filter agg sum 
start = Sys.time()
R_df = data[demand > 0
     , do.call(sum, .SD), .SDcols = 'demand'
     ,.(group_id)]

print(R_df)
stop = Sys.time()

print(paste0("Time: ", stop - start))


# Rolling mean
start = Sys.time()
data[,rolling_mean:=frollmean(demand, 10)
     ,.(product_id, store_id)]

print(data)
stop = Sys.time()
print(paste0("Time: ", stop - start))


# Join
start = Sys.time()
R_df = data[demand > 0
            , do.call(sum, .SD), .SDcols = 'demand'
            ,.(group_id)]
data = merge(data,
             R_df,
             "group_id")
print(data)
stop = Sys.time()
print(paste0("Time: ", stop - start))
