test_linux_chrome_latest:
	python3 -m robot --variable platform:"linux" --variable browserName:Chrome --variable version:latest --variable visual:true --variable network:true --variable console:true Tests/*.robot

test_linux_firefox_latest:
	python3 -m robot --variable platform:"linux" --variable browserName:Firefox --variable version:latest --variable visual:true --variable network:true --variable console:true Tests/*.robot

test_windows_10_edge_latest:
	python -m robot --variable platform:"Windows 10" --variable browserName:MicrosoftEdge --variable version:latest --variable visual:true --variable network:true --variable console:true Tests/*.robot

test_windows_10_chrome_latest:
	python -m robot --variable platform:"Windows 10" --variable browserName:Chrome --variable version:latest --variable visual:true --variable network:true --variable console:true Tests/*.robot

test_mac_firefox_latest:
	python3 -m robot --variable platform:"MacOS Catalina" --variable browserName:Firefox --variable version:latest --variable visual:true --variable network:true --variable console:true Tests/*.robot

test_mac_chrome_latest:
	python3 -m robot --variable platform:"MacOS Catalina" --variable browserName:Chrome --variable version:latest --variable visual:true --variable network:true --variable console:true Tests/*.robot