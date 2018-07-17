# Data Scientist

## Description

A music streaming service has challenged you with a new task.

In this task, you will be asked to predict the chances of an user listening to a song repetitively after the first observable listening event within a time window was triggered. If there are recurring listening event(s) triggered within a month after the user’s very first observable listening event, its target is marked 1, and 0 otherwise in the training set.

## Goal

Create a model able to predict the value of target (i.e. target = 1 if an user will listen again to the song within a month, target = 0 if not). Train and test your model using the provided dataset.

## Dataset composition

The dataset is composed of the following features: 

* *msno*: user id

* *song_id*: song id

* *source_system_tab*: the name of the tab where the event was triggered. System tabs are used to categorize functions. For example, tab my library contains functions to manipulate the local storage, and tab search contains functions relating to search.

* *source_screen_name*: name of the layout a user sees.

* *source_type*: an entry point a user first plays music on mobile apps. An entry point could be album, online-playlist, song .. etc.

* **target** (not a feature but target variable): this is the target variable. target=1 means there are recurring listening event(s) triggered within a month after the user’s very first observable listening event, target=0 otherwise

* *city*

* *bd*: age. Note: this column has outlier values, please use your judgement.

* *gender*

* *registered_via*: registration method

* *registration_init_time*: format %Y%m%d

* *expiration_date*: format %Y%m%d

* *song_length*: in ms

* *genre_ids*: genre category. Some songs have multiple genres and they are separated by |

* *language*

* *remaining_days*: number of days between the registration_init_time and the expiration_date
