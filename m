From: Chris <email.bug@arcor.de>
Subject: Re: udev rules and scripts (erc timeout fix)
Date: Wed, 25 Feb 2015 15:37:51 +0100
Message-ID: <20150225153751.0c5f5df3@smtp.arcor.de>
References: <1964706709.59890.1424451282393.JavaMail.ngmail@webmail11.arcor-online.net>
	<B639B66A-F606-43CD-8FCC-D1A7810762D1@gmx.de>
	<20150222112309.7fa20ad0@smtp.arcor.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/PtKG85qmQcTw3teaTLR1V3F"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150222112309.7fa20ad0@smtp.arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--MP_/PtKG85qmQcTw3teaTLR1V3F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Hello,

managed to test and bugfix the udev rules.

Simply dropping all files into /etc/udev/rules.d/ is enough, and
an "udevadm test /block/<drive_dev>/<partition_dev>" (dryrun) for a
raid member seems to run ok and tells me it would execute the
appropriate script.

However, for me, un- and re-plugging a device still does not seem to
execute the script. The _possibly-redundant-disk.sh currently logs
into /tmp/timeout-tst, but udev events don't appear there.

If you have the possiblity to test this in your /etc/udev/rules.d/
setup, it would be much appreciated.

Cheers,
Chris




# /etc/udev/rules.d/99-test_mdadm_smartctl-timeouts.rules

SUBSYSTEM!="block", GOTO="md_inc_end"

# handle potential components of arrays (the ones supported by md)
ENV{ID_FS_TYPE}=="linux_raid_member", GOTO="md_inc"

# "noiswmd" on kernel command line stops mdadm from handling
#  "isw" (aka IMSM - Intel RAID).
# "nodmraid" on kernel command line stops mdadm from handling
#  "isw" or "ddf".
IMPORT{cmdline}="noiswmd"
IMPORT{cmdline}="nodmraid"

ENV{nodmraid}=="?*", GOTO="md_inc_end"
ENV{ID_FS_TYPE}=="ddf_raid_member", GOTO="md_inc"
ENV{noiswmd}=="?*", GOTO="md_inc_end"
ENV{ID_FS_TYPE}=="isw_raid_member", GOTO="md_inc"
GOTO="md_inc_end"

LABEL="md_inc"

# initialize redundancy possibility status
# (only the kernel module could set actual run-time state, and may in the future
# set a dynamic FASTFAIL kernel device property instead of calling smartctl-timeout scripts)

IMPORT{program}="/sbin/mdadm --examine --export $tempnode"
ENV{MD_LEVEL}=="raid[1-9]*", ENV{REDUNDANT_DEV}="possibly"
ENV{MD_LEVEL}=="raid0", ENV{REDUNDANT_DEV}="false"


LABEL="md_inc_end"


# call initial HDD error correction timeouts adjustment
ENV{DEVTYPE}=="partition", ENV{REDUNDANT_DEV}=="possibly", TEST=="/usr/sbin/smartctl", RUN+="/etc/udev/rules.d/smartctl-timeouts_possibly-redundant-partition.sh $parent"
ENV{DEVTYPE}=="partition", ENV{REDUNDANT_DEV}=="false|", TEST=="/usr/sbin/smartctl", RUN+="/etc/udev/rules.d/smartctl-timeouts_non-redundant-partition.sh $parent"
ENV{DEVTYPE}=="disk", ENV{REDUNDANT_DEV}=="possibly", TEST=="/usr/sbin/smartctl", RUN+="/etc/udev/rules.d/smartctl-timeouts_posibly-redundant-disk.sh $devnode"
ENV{DEVTYPE}=="disk", ENV{REDUNDANT_DEV}=="false", TEST=="/usr/sbin/smartctl", RUN+="/etc/udev/rules.d/smartctl-timeouts_non-redundant-disk.sh $devnode"




















--MP_/PtKG85qmQcTw3teaTLR1V3F
Content-Type: application/x-gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename=smartctl-timeouts_udevadm-test.tar.gz

H4sIAH7W7VQAA+0da3PaSDKf9Ssm2HWxc4DBz0uuvHvEJhvq/EgB2a2t3SsyRgPorAerkYy5xP/9
untmJAGyDTZxkl20W+WANDM9/e6ebhHb4qrk2aWQO3aJSym8C3dcDmNXyNLIiQalyPFEEEfy2cOv
Clz7+7v4t3qwV8n+xWt3b3/nWXV792BnZ3d7fx++r+7v72w/Y5VHrDn3FcuIh4w96/bvfu6++9/p
tcbsgPlBxITtRCwaOJL1HFcUGXwaOa7LLgQLrkQ4Cp0oEj4LfBYPbR4Jy1pjx4H/ImLDMOgKKRn3
x0xcCT+SzOnBJ94NfJszmDGMfd/x+4zL9OuLEL6RMBnMg8zHgBEdmId53I+5646t+tnPn2pntaPz
s+PazeFh4ceXhSL76bx9fljw7I7jdzvCtwswXLOtYJ7NeBjysbSs1oc3rV9b7frp88PChRt0L3PH
wuAB920YOgxgd5HDXdYNvGHg0zaCnp6PbUQDwIMP4Ml4OAzCSNjsYgwLbhKYjePO21an/ev7OgLq
On583cFNdTwATIRTa9O6BT9w5MizC4jSSxH6gpaG3dsMJhBMRsEQsGFz22O9MPAUpIA0GMwKMLbA
NvglZ43T1ikrsYYfwQzNWuN4s6ymtz0E4THzByEr2HavULYap+/Pm+1PXQ+fEDeHCfR5d/TCFqHG
fLyDgrMYhEXvxJ+amCBYaF4Ycee8ORxyUntTP5mgnOM7yCjO/wQLhR0DM/vdMTCQlM6F4zrRGFDL
o1jCoxuB744Z8o6mgBfYoFqBELFrMykixrsRcDtKCGlaGgrSh1Ty+BjWotG9OIpDARPSEGaPfe45
Xfa21mq/rTVOzOxKhFAghyKMcLSMBLeRj7sgUiiC0uNh1I1co9eZ7IbOMJKblqEkjO6H3ANKvmmc
HTeaW4pFSiVxDYsC4+C/UATYeiS8IdBXKFSfHndO6j/XTxDRiOTfqqVX/0HK4M1m/fgDyPFZu3Nc
/xnmVuhyx/lDK7eM6nFXCiJCKBQJ2TiIYXM+8LSHKmvAI9YXILs8joItIBk+6EeoUBI9gaILU9C+
yqCNeht7my8ke1H70D5/QaiXwhXdyLkSMGo0cECyHBmxWCIGX9SazdqvL6zaUbtxfgYAc9v+3AXh
6QuA+j4kZiDKQSR8FfRAGEEfr3+CLZ80zv7duincspbGXKtda7brx4i7l7EveU+8TG++PW/WGz+d
4U0/0F8rxXjc+QUQ27r5OzI3AFdyuYxKoZAA0b/WhX+FwwGGxlH9pozcEmbggD2AVdDzgYy9r7Xf
JZLY/HD29+mNN3psHZgWdzjk0YDRAmbgfRM/n2PiaVHV4gt0RtY3QsveHR8zEYag2bpBGCKRQT0a
H4dx+7/gDyB5iC1h90ZzDEFsHHw4nzMzDF1k7XqrDd9sxTLckheOv2WEbnoL08IoO2aWktEsUSlZ
uSwBbfAJoCssDB5JzufHAecH/qJw2Y68/OIYm0IYrkkwgTpMtdOcQCkNs0Q0zULztV2+iWsW/HwK
P2YNdPIPDvZu8/+r+zu7xv+vbh9U0f8/2N1f+f9Pca093yLuHqBzMScvoFJtmjuoPJXuDAU7AyPe
ZFGAUUMUOv2+CMlPjoH5GQWVz2HsG9HlsUR/WjtHWTcqDK4cG+3spMd06QcjSQ9PeUzkCyTDledV
JI9AKXMMZNCkkxWg+EZ5PMaJQs8AHeYPCYg0mGCzRSRC8nkSZZUsFhVMxFKGaOOo2XgPOqTRPCys
b9hOSKYO/hmC+wV+1yUr9eBjpbAJ/1lltp4OyFEgtujx2I0gigFrhYoJJq2CLcsoq0br34eF7kB0
LwFV5BC1z4/PrbUeGDbcCPiNH7s225JjuUXhz9b6Jz3ZDfsncyUr2Sz96uVH+NIO0POH0E38EV9x
VyBtAyIdOEd3GZV/Il18HMzY+jSQ2mWDmz3HWrMhhrLWYI3fZp9MtsP+w9Ipp5+Kwhing8msvGnY
IVOPwCS/a7S8Zuxvf2NI/4SLJUQ7VwLYFEJapHJXB3TEqNxFso0tAoHdQ6wcTV+1BOz53pE5tj4z
BWzwKeR/jg09eo179P9BFZQ96v/tne3q7sE+6P+9/YODlf5/imte/a95YaX6v47qF91BwAo12hZi
aF3fTkKX1wXSh89Bqbcbp42znzpHp8c3bAsAzar+z6wfiiEr/cGOHckpFv7dIvU4/0gpMIMnjXpk
bI3Vm0cGEsz3YT4xzZNt4EfbLIcEofsi2nyth79kLRERhWHmKAxcFwJ7M59iKbghHVuEHAnhBnT5
/bKegLESaweo4oMRzWOHELzj0D7+jYfACpKg5BHG2vABWBO+E24vO8eJBkMND0UUh8BMOqHCkKIq
eCwyGcCDPJri4WQqprkZRm14dpG5V16RXURhDxi0XC5vEqOFooRpVUGTXMDcZKmz8ACRLjPLohTE
Er6QwCNo413AAXO2AjUSGQPgdAJbMszdZ6DxAx31ekJK3hdSQY8pJiQGIHjEIzDAJLIBblUTLwoI
OpDZsJgB7AIIM+IO8SJJFkEiB5TXGoaUBmaxLzAxzMNxlq4AvVC5VZg4AyKmX0ODeuQSxQ8QpMsh
8Buu5IIk4sAU4Vs2j7jCmBKRYxqOu0feyfKlZsgich7BfXZ+lvoOH85aH5r1ztH5Wbt5fnJSb3aa
9Va93WnVMf/cYhvrnxZ5/kaCsCdQLTiW/ZDrt20ppbOlN2ScjNYvjfbRu87b5vlp57z9DmaDWd42
foIljjut01qzfdQ+6YBo188/tNMUGqKdSJEjc0VK4OONntOPAdsM/MEYeUQScZ0gliCGMNgih/E3
cDaBm+aB+iM4aIuh43WpVL0hbw7x+fnzI1dDJzG7lkbM8lZ7f95qNd6c/NpZdE1YMVGpCxJVOcWp
FBBhickzxKUkPwdxH4hwlrYb829TbqJaWP+0wAZ3KjdyQiAWGzunRMDsSiaQuZG1Z13sRB1wfzzi
Y+L0FBc0VIUVi0AIU4se+Ar2DXsO8UfyMRPJMJZSJ4c2GWM397qok+Z+OFFIi1Ngfuxn8L+4Xij1
I7ZTmcZYytF23J1FmsYZjNNeSWFyHNyYH3gKUZM/GGHSLh7kUWndsb6QIE8Gr+kky+LFTECsJt4Q
18NwESL9/pJVK2D/9yqbAGxoDpfiELO/E+ZWaZUJpTbjJxqnsIgfUiksogcyAFtD4XnB49eO5/wP
t6C9kRzBKe0ZDkidStQADvHHQeK0ZvxFcmswnvgjdrqX7ADgUd43bskWNgQI6AGpw2l0K2TWNauh
ryln4xeEKVBTUsgAGEIfZVL7YjRFPk6+C5jxii5ELwjF9K61D4Xf5rpNBDN4yVLIaWeJzrddiG4w
9pnVSVkKZRGn5GpCFIoHFfh/RiB+UN/4sesqKXqiTMbqesg1G4I267Xj0/oy17in/mdvt3qg8j/b
1d29Xcz/7OxUVvU/T3JZMwzAFANYFirI2bu6XsCkWDJKCZUPKbb0OLUL8RtGbhaokpxUDY7oOddU
l0JZF8+BBSEORU1kUiEUzGkFTFGrRanbJKINQUFdCYgxjdrKGpLRwOkOyJYEPSxfclEfAzCkCTGc
LOt9ml2FwiQcuOuKqQwWs+NQgUZ1FkkhCMeUctHC7cDzE9krRILCgTFeSanHDEKYOtkHmOq0odzc
GBkIA4HOkGEYLwfOUKFKZytSsC2K9TNlKwhGQiQ8MoAvnJDNJroyea6az7gbwdZ4pFMrMEimmEMY
Luh7xwdKRU6fa7NmqlSsnuBYxmKKWhSeYOqz83b9NTtS5/FMXItuTMfyGtsXWA4RCjCpoclbAJsB
17Eh717yPu7fhz+h1F7cIAguE85NbOLtrOz4mjSIopB7PdyvZTVrWJNQO9GiMMVtG2ApNxOee+mB
MLxEBMgBJk4Qpdy/xVmB2c/RDRg5Ukxkd6jgTiVIZ4x9kXhX85HtEKoSLrYwJQWuqkNuFc8SEASy
mJM4IbRwRlsZOH3imguu6pcsrHvTnkoKnpJvsyJIlqAMFpAafDhHDlQqKMvWsM8G5hGUb2IHYiIz
qDUIDjPJuST9kI83C5GMOKYiGi4xm3gRXIk0ZfcC+RC8RXDqcpRDGcHBeiGb6hZHFA4iO106Pvmx
lMTSopXAggN0YstFxkJ50XuySN5aR+28RFOZbSQ8WHKB2YAruso3wgygRQVXNRi7YbJVoNeoRGso
uk7P6aYimmo0GPY2yJdUILR8zWCHmQpFhMYBd2+c5l+18BH8RczhTjvliixp6s849zlOt+f4oLUS
z1vr0pwHYVrS7+CXItU2YOpFUkCbFp1rKhNgsAVoR8gTbNfglgD54UqlKb/YxfzmdDmGLFqABTwm
UMlg3GmSOpYisTUBGCcfOFurxymOCkU/dnnouGNLO+lcJ9Rgt+YEBBWnzMGIsjSEk5SZs1VnqnIw
d8tWIkBYqRbPblLxwqYSI6PkaD5u82GUtbKWgaeIlkub3DKrXztKMrEYt4fHLiHAjkVTwBoQx0yw
u4ocJNvgqEotUCQ9AewZ+NwtpnFUMcOrMCQewpKi3C9jHWqISlyKEPAqmYi65U02IhG9EJayiTBc
XHfFMFImLhERIxlkgVkwpLNd0t50Hm69ZLcULYGoIM/Sv0FbkLHURIPNUATKWSRkZARGHx1R5SbY
mfR8CFOl5mgZD5ZVYlt5QjmHzPpwWelfZBoKkyagLCLr0aHVLO8qcDBcBpYp4wZhYamCTtLVMzG4
/JHMYolNTvSazjWyuVxWyIurU/EuZOfWpnZjNsMGfKfKW7kryZNSQpENJotkB8h/5Kxg8iYFBS9t
iuxGxloZyGZPBx0SVI9fiqQsNq3ik3hmUcghf4H5QtjArxgLUzkm1bb89QLVhUsQH7DGffVfe1VV
/7Vd3ascbB88q2xX9quVVfz3FNfac3ZXAcA9zECFR5mD9SQrNRFdFDznWpgcWkG5XCjQ3PFTpYR9
HHQ0nDVkqbou41I1hhXY2J2Sk9hPnkWVIPwgBqcWNIPUR7rZPNkLrM1PQISHcqZLzRpZHJ5q/Ekd
K13wniMXC8ovRHL8bBKJEwctM6lr8tn12gLbNgw6+VXg2ARZiDo/9rEGwlc2ZcKllQppoMuov0b5
8+jGYt3zrNdRZr+AUy8SoMjdjLu4Pb0n7a0ZoIqIKITIE9yXqWFLgDBhH6GG8qWU+swGQMpVXgOT
jlbB+DKaS7QHUSRfFcIX4aNHI5PD9VAkbUh+oEMhmCsbCyUhiUqoJjZDh/eLFWg8pmTra8vyQ65F
9vjQNe7R//sHVdP/t1fZg3/j3Z2dlf5/iuvu+q/beeFbKnxSz3zErsSPr9kdzxbYDz+wrcgbmgOt
UiSjr1U39aiqqUfWTD2+Ympp9VJLqJZaUq3Uciulll4ntYwqqW+xRmpVIfVXq5D60xdGPaQEbKZC
6oGTfI1SqYeAutSaqcUBQGW1+KjZKqoHzLFARdJSCpGWU4lkSpGWTOu56oMm4+i8Ap87K4Lmrtr5
Dqp1tN8FXkQ2xFZ1THNUMBXTsw6wVB6E/hnoDfbxlkkAsI1+ENjIfbboh9zWviimdW5L1eALJyTG
ArTkpoIb5u6062ftd63DR1WdaXCN64SHAir34fHrsjlkI8WdUVDp4lRl+OrVq2klkwGvALcLqfQZ
BaSr0HJqpO7kPTAftNssDFuwm49Gk0yWVGUeK04M+VJFVot0eT80xrwv/2vqf7D/t1o5WMX/T3jd
Hf/fzgtWpplLpekwQkqPfPLVAoVApE5HMADPf0DFwkyxnzmMw3NKV5VQpInkv26T7VjIz8mrEu5s
tU3fqbK0blvTvXtXu616JlNe/CXbbW95ucL31HL7TV1zYvhRa9zX/7u7X5nq/93f3V+9/+FJrkX0
/zeY+tVKKTddonIktZMT0lQQhpCiusmGNokPiNGEjjboPXaTlQ4TscNEstQO6FGTS3M8fB0NncQl
tX7TLl6leHfN/Cq7u8ruPia7O4coqAq1WPxZ8ryWsv4qS/LAo5wHHubclb6Y90BnOV3w32Ju/8tS
XecwTaC/IOlMXsskthbLgd+d0tJcoRdY0jFCks94sqOEhyb4H9wC/ch1H3CwkNDKrPuU5wSLsdx+
ckJwm2DNM8VC/bCZdl5zTjCZ9bv/iCDNwi1PwqZbhHMOCQxtFllzRsnNfxrwQIosRo0kI2nOBBRV
av604UE65aTMlZFRBdXZeq+58udfKvV8V/K5PJudfVzyOFlx3vzx/BnkW3LIWVJ92UTyMlLJSQ//
lDNj3JaJjfQCkMncx57Yx/iiXkYidn/OTubbw/HlrXFP/+9O5v3/u7uU/9+t7u2t8j9PceFb/E2j
bSxV3Htrp+Rr7NWcX8QOC9V/7GAyujXQDSEjfJc+NkkKbI+j9h94ZBPfwYZrU2Ide5duafIiE2JU
dxRALM9DqrxW0XRZFU9TEJ6jS5WbpqNzAIJ6B6m+2VixnJ5B084z4KE92Y2F+5pqQfvgww6iGOug
3XFRd5OpJhzdcyiF8HBJfUrCbco4kWOZZFowcAzZMKauSmGX85E+FdIfFhDRjZ7ObRWz9p3eh55E
nrNHt4Ryqr8nIBSeHM0PXN7axbrGjmCIIiduSafVMFWCVejaBOSsxXqxS3Qzp9v5HXY6N0XtXFQZ
nxauT/R76cJ76oKOsB7d5f6lcoA8D5t7wHCtMQRZMYjKGmGzGhsFISWLqMY/2+2I9B7xUBR1uxEW
wivujELnQvcnG8ExvQKqo90OcEbqt0tSP4hd7L0jcKl1NmnHdjCAX2PvghHwdVhMWH+iRt/0uylm
AvsKT6k2+QsRjQQd3ky9TtELbCGTzBZulPojywqZi3iph4V9EuNTVeuvqa1dOSRg6rwpmd7fod+g
AG5UpMgi1kgjVfXrnFvS45dph8AJzgJiDZ1YJA9tsk0B3LCkpUwGyMCJQ5fbAKHbCifThiKceSM8
kksnRsvsvWm2xbPOubJr1GUcwiTqqBN3age3rZWsRNvXDblpf0q2DoaaYBYPrg8Lu/+4jX4yQKqV
9iTbnGzBHlOsFyX51MzLNhMpxjcHBGpjt9LbeIL30xtfLTr/lrZfzW4pfesOfpFkggnaZQBoWamD
nfdu+LTPu2AhBCX8aZ3Y1/8EwotrJ/q2XMhXr0rY5dqhX1PozFh+9UtQj1zjPv9vp7Kb/v7Tzjae
/1VW739/mmv1Q0mrH0pa/VDSI38oSVmBb/B3kr6jn8TZElF3C+uBtsjklO1v9Ndx5oHza/5Qzpx4
/Dq/mbM48mYBm72+tg1dXatrda2u7/H6PzrPdxIAeAAA

--MP_/PtKG85qmQcTw3teaTLR1V3F--
