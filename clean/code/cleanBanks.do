set more off, perm

cd "/Users/murpheis/Dropbox/UCB/TechChange"


infix ///
   str v1 1-1               v2 2-4                   v3 5-6  ///
   str v4 7-8               str v5 9-25              str v6 26-29  ///
   v7 30-32                 v8 33-41                 v9 42-50 ///
   v10 51-59                v11 60-68                v12 69-77 ///
   v13 78-86                v14 87-95                v15 96-104 ///
   v16 105-113              v17 114-122              v18 123-131 ///
   v19 132-140              v20 141-149              v21 150-158 ///
   v22 159-167              v23 168-176              v24 177-185 ///
   v25 186-194              v26 195-203              v27 204-212 ///
   v28 213-221              v29 222-230              v30 231-239 ///
   v31 240-248              v32 249-257              v33 258-266 ///
   v34 267-275              v35 276-284              v36 285-293 ///
   v37 294-302              v38 303-311              v39 312-320 ///
   v40 321-329              v41 330-338              v42 339-342 ///
   v43 343-346              v44 347-350              v45 351-354 ///
   v46 355-358              v47 359-362              v48 363-366 ///
   v49 367-370              v50 371-374              v51 375-378 ///
   v52 379-382              v53 383-386              v54 387-390 ///
   v55 391-394              v56 395-398              v57 399-402 ///
   v58 403-406              v59 407-409              v60 410-412 ///
   v61 413-415              v62 416-418              v63 419-421 ///
   v64 422-424              v65 425-427              v66 428-430 ///
   v67 431-433              v68 434-436              v69 437-439 ///
   v70 440-442              v71 443-445              v72 446-448 ///
   v73 449-451              v74 452-454              v75 455-457 ///
   v76 458-466              v77 467-475              v78 476-484 ///
   v79 485-493              v80 494-502              v81 503-511 ///
   v82 512-520              v83 521-529              v84 530-538 ///
   v85 539-547              v86 548-556              v87 557-565 ///
   v88 566-574              v89 575-583              v90 584-592 ///
   v91 593-601              v92 602-610              v93 611-619 ///
   v94 620-628              v95 629-637              v96 638-646 ///
   v97 647-655              v98 656-664              v99 665-673 ///
   v100 674-682             v101 683-691             v102 692-700 ///
   v103 701-709             v104 710-718             v105 719-727 ///
   v106 728-736             v107 737-745             v108 746-754 ///
   v109 755-763             v110 764-772             v111 773-781 ///
   v112 782-790             v113 791-799             v114 800-808 ///
   v115 809-817             v116 818-826             v117 827-835 ///
   v118 836-844             v119 845-853             v120 854-862 ///
   v121 863-871             v122 872-880             v123 881-889 ///
   v124 890-898             v125 899-907             v126 908-916 ///
   v127 917-925             v128 926-934             v129 935-943 ///
   v130 944-952             v131 953-961             v132 962-970 ///
   v133 971-979             v134 980-988             v135 989-997 ///
   v136 998-1006            v137 1007-1015           v138 1016-1024 ///
   v139 1025-1033           v140 1034-1042           v141 1043-1051 ///
   v142 1052-1060           v143 1061-1069           v144 1070-1072 ///
   v145 1073-1075           v146 1076-1078           v147 1079-1081 ///
   v148 1082-1084           v149 1085-1087           v150 1088-1090 ///
   v151 1091-1093           v152 1094-1096           v153 1097-1099 ///
   v154 1100-1102           v155 1103-1105           v156 1106-1108 ///
   v157 1109-1111           v158 1112-1114           v159 1115-1117 ///
   v160 1118-1120           v161 1121-1123           v162 1124-1126 ///
   v163 1127-1129           v164 1130-1132           v165 1133-1135 ///
   v166 1136-1138           v167 1139-1141           v168 1142-1144 ///
   v169 1145-1147           v170 1148-1150           v171 1151-1153 ///
   v172 1154-1156           v173 1157-1159           v174 1160-1162 ///
   v175 1163-1165           v176 1166-1168           v177 1169-1171 ///
   v178 1172-1175           v179 1176-1179           v180 1180-1183 ///
   v181 1184-1187           v182 1188-1191           v183 1192-1195 ///
   v184 1196-1199           v185 1200-1203           v186 1204-1207 ///
   v187 1208-1211           v188 1212-1215           v189 1216-1218 ///
   v190 1219-1221           v191 1222-1224           v192 1225-1227 ///
   v193 1228-1230           v194 1231-1233           v195 1234-1236 ///
   v196 1237-1239           v197 1240-1242           v198 1243-1245 ///
   v199 1246-1248           v200 1249-1251           v201 1252-1254 ///
   v202 1255-1257           v203 1258-1260           v204 1261-1263 ///
   v205 1264-1266           v206 1267-1269           v207 1270-1272 ///
   v208 1273-1275           v209 1276-1278           v210 1279-1281 ///
   v211 1282-1284           v212 1285-1288 ///
using  "/volumes/My Passport for Mac/data/ICPSR_00007/DS0001/00007-0001-Data.txt", clear


label var   v1 "DATA TYPE"
label var   v2 "YEAR"
label var   v3 "ICPR STATE CODE"
label var   v4 "CONG DIST NMBR"
label var   v5 "COUNTY NAME"
label var   v6 "CATALOG ENTRY NMBR"
label var   v7 "TABLE NUMBER"
label var   v8 "FDIC DEPOSITS 1920     S"
label var   v9 "FDIC DEPOSITS 1921     S"
label var   v10 "FDIC DEPOSITS 1922     S"
label var   v11 "FDIC DEPOSITS 1923     S"
label var   v12 "FDIC DEPOSITS 1924     S"
label var   v13 "FDIC DEPOSITS 1925     S"
label var   v14 "FDIC DEPOSITS 1926     S"
label var   v15 "FDIC DEPOSITS 1927     S"
label var   v16 "FDIC DEPOSITS 1928     S"
label var   v17 "FDIC DEPOSITS 1929     S"
label var   v18 "FDIC DEPOSITS 1930     S"
label var   v19 "FDIC DEPOSITS 1931     S"
label var   v20 "FDIC DEPOSITS 1932     S"
label var   v21 "FDIC DEPOSITS 1933     S"
label var   v22 "FDIC DEPOSITS 1934     S"
label var   v23 "FDIC DEPOSITS 1935     S"
label var   v24 "FDIC DEPOSITS 1936     S"
label var   v25 "FDIC DEPOSITS SUS 1920 S"
label var   v26 "FDIC DEPOSITS SUS 1921 S"
label var   v27 "FDIC DEPOSITS SUS 1922 S"
label var   v28 "FDIC DEPOSITS SUS 1923 S"
label var   v29 "FDIC DEPOSITS SUS 1924 S"
label var   v30 "FDIC DEPOSITS SUS 1925 S"
label var   v31 "FDIC DEPOSITS SUS 1926 S"
label var   v32 "FDIC DEPOSITS SUS 1927 S"
label var   v33 "FDIC DEPOSITS SUS 1928 S"
label var   v34 "FDIC DEPOSITS SUS 1929 S"
label var   v35 "FDIC DEPOSITS SUS 1930 S"
label var   v36 "FDIC DEPOSITS SUS 1931 S"
label var   v37 "FDIC DEPOSITS SUS 1932 S"
label var   v38 "FDIC DEPOSITS SUS 1933 S"
label var   v39 "FDIC DEPOSITS SUS 1934 S"
label var   v40 "FDIC DEPOSITS SUS 1935 S"
label var   v41 "FDIC DEPOSITS SUS 1936 S"
label var   v42 "FDIC BANKS 1920        S"
label var   v43 "FDIC BANKS 1921        S"
label var   v44 "FDIC BANKS 1922        S"
label var   v45 "FDIC BANKS 1923        S"
label var   v46 "FDIC BANKS 1924        S"
label var   v47 "FDIC BANKS 1925        S"
label var   v48 "FDIC BANKS 1926        S"
label var   v49 "FDIC BANKS 1927        S"
label var   v50 "FDIC BANKS 1928        S"
label var   v51 "FDIC BANKS 1929        S"
label var   v52 "FDIC BANKS 1930        S"
label var   v53 "FDIC BANKS 1931        S"
label var   v54 "FDIC BANKS 1932        S"
label var   v55 "FDIC BANKS 1933        S"
label var   v56 "FDIC BANKS 1934        S"
label var   v57 "FDIC BANKS 1935        S"
label var   v58 "FDIC BANKS 1936        S"
label var   v59 "FDIC BANKS SUS 1920    S"
label var   v60 "FDIC BANKS SUS 1921    S"
label var   v61 "FDIC BANKS SUS 1922    S"
label var   v62 "FDIC BANKS SUS 1923    S"
label var   v63 "FDIC BANKS SUS 1924    S"
label var   v64 "FDIC BANKS SUS 1925    S"
label var   v65 "FDIC BANKS SUS 1926    S"
label var   v66 "FDIC BANKS SUS 1927    S"
label var   v67 "FDIC BANKS SUS 1928    S"
label var   v68 "FDIC BANKS SUS 1929    S"
label var   v69 "FDIC BANKS SUS 1930    S"
label var   v70 "FDIC BANKS SUS 1931    S"
label var   v71 "FDIC BANKS SUS 1932    S"
label var   v72 "FDIC BANKS SUS 1933    S"
label var   v73 "FDIC BANKS SUS 1934    S"
label var   v74 "FDIC BANKS SUS 1935    S"
label var   v75 "FDIC BANKS SUS 1936    S"
label var   v76 "FDIC NTL DEPOSITS 1920 S"
label var   v77 "FDIC NTL DEPOSITS 1921 S"
label var   v78 "FDIC NTL DEPOSITS 1922 S"
label var   v79 "FDIC NTL DEPOSITS 1923 S"
label var   v80 "FDIC NTL DEPOSITS 1924 S"
label var   v81 "FDIC NTL DEPOSITS 1925 S"
label var   v82 "FDIC NTL DEPOSITS 1926 S"
label var   v83 "FDIC NTL DEPOSITS 1927 S"
label var   v84 "FDIC NTL DEPOSITS 1928 S"
label var   v85 "FDIC NTL DEPOSITS 1929 S"
label var   v86 "FDIC NTL DEPOSITS 1930 S"
label var   v87 "FDIC NTL DEPOSITS 1931 S"
label var   v88 "FDIC NTL DEPOSITS 1932 S"
label var   v89 "FDIC NTL DEPOSITS 1933 S"
label var   v90 "FDIC NTL DEPOSITS 1934 S"
label var   v91 "FDIC NTL DEPOSITS 1935 S"
label var   v92 "FDIC NTL DEPOSITS 1936 S"
label var   v93 "FDIC NTL DEP SUS 1921  S"
label var   v94 "FDIC NTL DEP SUS 1922  S"
label var   v95 "FDIC NTL DEP SUS 1923  S"
label var   v96 "FDIC NTL DEP SUS 1924  S"
label var   v97 "FDIC NTL DEP SUS 1925  S"
label var   v98 "FDIC NTL DEP SUS 1926  S"
label var   v99 "FDIC NTL DEP SUS 1927  S"
label var   v100 "FDIC NTL DEP SUS 1928  S"
label var   v101 "FDIC NTL DEP SUS 1929  S"
label var   v102 "FDIC NTL DEP SUS 1930  S"
label var   v103 "FDIC NTL DEP SUS 1931  S"
label var   v104 "FDIC NTL DEP SUS 1932  S"
label var   v105 "FDIC NTL DEP SUS 1933  S"
label var   v106 "FDIC NTL DEP SUS 1934  S"
label var   v107 "FDIC NTL DEP SUS 1935  S"
label var   v108 "FDIC NTL DEP SUS 1936  S"
label var   v109 "FDIC NTL DEP SUS 1937  S"
label var   v110 "FDIC STATE DEP 1920    S"
label var   v111 "FDIC STATE DEP 1921    S"
label var   v112 "FDIC STATE DEP 1922    S"
label var   v113 "FDIC STATE DEP 1923    S"
label var   v114 "FDIC STATE DEP 1924    S"
label var   v115 "FDIC STATE DEP 1925    S"
label var   v116 "FDIC STATE DEP 1926    S"
label var   v117 "FDIC STATE DEP 1927    S"
label var   v118 "FDIC STATE DEP 1928    S"
label var   v119 "FDIC STATE DEP 1929    S"
label var   v120 "FDIC STATE DEP 1930    S"
label var   v121 "FDIC STATE DEP 1931    S"
label var   v122 "FDIC STATE DEP 1932    S"
label var   v123 "FDIC STATE DEP 1933    S"
label var   v124 "FDIC STATE DEP 1934    S"
label var   v125 "FDIC STATE DEP 1935    S"
label var   v126 "FDIC STATE DEP 1936    S"
label var   v127 "FDIC STATE DEP SUS 1921S"
label var   v128 "FDIC STATE DEP SUS 1922S"
label var   v129 "FDIC STATE DEP SUS 1923S"
label var   v130 "FDIC STATE DEP SUS 1924S"
label var   v131 "FDIC STATE DEP SUS 1925S"
label var   v132 "FDIC STATE DEP SUS 1926S"
label var   v133 "FDIC STATE DEP SUS 1927S"
label var   v134 "FDIC STATE DEP SUS 1928S"
label var   v135 "FDIC STATE DEP SUS 1929S"
label var   v136 "FDIC STATE DEP SUS 1930S"
label var   v137 "FDIC STATE DEP SUS 1931S"
label var   v138 "FDIC STATE DEP SUS 1932S"
label var   v139 "FDIC STATE DEP SUS 1933S"
label var   v140 "FDIC STATE DEP SUS 1934S"
label var   v141 "FDIC STATE DEP SUS 1935S"
label var   v142 "FDIC STATE DEP SUS 1936S"
label var   v143 "FDIC STATE DEP SUS 1937S"
label var   v144 "FDIC NTL BANKS 1920    S"
label var   v145 "FDIC NTL BANKS 1921    S"
label var   v146 "FDIC NTL BANKS 1922    S"
label var   v147 "FDIC NTL BANKS 1923    S"
label var   v148 "FDIC NTL BANKS 1924    S"
label var   v149 "FDIC NTL BANKS 1925    S"
label var   v150 "FDIC NTL BANKS 1926    S"
label var   v151 "FDIC NTL BANKS 1927    S"
label var   v152 "FDIC NTL BANKS 1928    S"
label var   v153 "FDIC NTL BANKS 1929    S"
label var   v154 "FDIC NTL BANKS 1930    S"
label var   v155 "FDIC NTL BANKS 1931    S"
label var   v156 "FDIC NTL BANKS 1932    S"
label var   v157 "FDIC NTL BANKS 1933    S"
label var   v158 "FDIC NTL BANKS 1934    S"
label var   v159 "FDIC NTL BANKS 1935    S"
label var   v160 "FDIC NTL BANKS 1936    S"
label var   v161 "FDIC NTL BANKS SUS 1921S"
label var   v162 "FDIC NTL BANKS SUS 1922S"
label var   v163 "FDIC NTL BANKS SUS 1923S"
label var   v164 "FDIC NTL BANKS SUS 1924S"
label var   v165 "FDIC NTL BANKS SUS 1925S"
label var   v166 "FDIC NTL BANKS SUS 1926S"
label var   v167 "FDIC NTL BANKS SUS 1927S"
label var   v168 "FDIC NTL BANKS SUS 1928S"
label var   v169 "FDIC NTL BANKS SUS 1929S"
label var   v170 "FDIC NTL BANKS SUS 1930S"
label var   v171 "FDIC NTL BANKS SUS 1931S"
label var   v172 "FDIC NTL BANKS SUS 1932S"
label var   v173 "FDIC NTL BANKS SUS 1933S"
label var   v174 "FDIC NTL BANKS SUS 1934S"
label var   v175 "FDIC NTL BANKS SUS 1935S"
label var   v176 "FDIC NTL BANKS SUS 1936S"
label var   v177 "FDIC NTL BANKS SUS 1937S"
label var   v178 "FDIC STATE BANKS 1920  S"
label var   v179 "FDIC STATE BANKS 1921  S"
label var   v180 "FDIC STATE BANKS 1922  S"
label var   v181 "FDIC STATE BANKS 1923  S"
label var   v182 "FDIC STATE BANKS 1924  S"
label var   v183 "FDIC STATE BANKS 1925  S"
label var   v184 "FDIC STATE BANKS 1926  S"
label var   v185 "FDIC STATE BANKS 1927  S"
label var   v186 "FDIC STATE BANKS 1928  S"
label var   v187 "FDIC STATE BANKS 1929  S"
label var   v188 "FDIC STATE BANKS 1930  S"
label var   v189 "FDIC STATE BANKS 1931  S"
label var   v190 "FDIC STATE BANKS 1932  S"
label var   v191 "FDIC STATE BANKS 1933  S"
label var   v192 "FDIC STATE BANKS 1934  S"
label var   v193 "FDIC STATE BANKS 1935  S"
label var   v194 "FDIC STATE BANKS 1936  S"
label var   v195 "FDIC ST BANKS SUS 1921 S"
label var   v196 "FDIC ST BANKS SUS 1922 S"
label var   v197 "FDIC ST BANKS SUS 1923 S"
label var   v198 "FDIC ST BANKS SUS 1924 S"
label var   v199 "FDIC ST BANKS SUS 1925 S"
label var   v200 "FDIC ST BANKS SUS 1926 S"
label var   v201 "FDIC ST BANKS SUS 1927 S"
label var   v202 "FDIC ST BANKS SUS 1928 S"
label var   v203 "FDIC ST BANKS SUS 1929 S"
label var   v204 "FDIC ST BANKS SUS 1930 S"
label var   v205 "FDIC ST BANKS SUS 1931 S"
label var   v206 "FDIC ST BANKS SUS 1932 S"
label var   v207 "FDIC ST BANKS SUS 1933 S"
label var   v208 "FDIC ST BANKS SUS 1934 S"
label var   v209 "FDIC ST BANKS SUS 1935 S"
label var   v210 "FDIC ST BANKS SUS 1936 S"
label var   v211 "FDIC ST BANKS SUS 1937 S"
label var   v212 "IDENTIFICATION NUMBER"


* SAVE FULL DATASET, WIDE
save ./clean/output/FDICbanks.dta, replace


* LIMIT TO CERTAIN VARIABLES
rename v1 level
rename v3 stateicp
rename v5 countyname
keep level  stateicp countyname v42-v75
rename v* banks*
reshape long banks, i(level stateicp countyname) j(year)
gen type = "tot" if year >= 42 & year <=58
replace type = "sus" if year >58
replace year = year - 17 if type == "sus"
reshape wide banks, i(level stateicp countyname year) j(type) str
replace year = year -42 + 1920
merge m:1 stateicp countyname using ./clean/output/statecountybridge.dta
keep if _m == 3 // all master data counties matched
drop _m
save ./clean/output/FDICbanks_long.dta, replace
