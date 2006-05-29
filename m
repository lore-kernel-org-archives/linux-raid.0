From: dean gaudet <dean@arctic.org>
Subject: Re: raid5 hang on get_active_stripe
Date: Mon, 29 May 2006 13:56:32 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0605291354260.30134@twinlark.arctic.org>
References: <5d96567b0603060346r768a0ee1i8d8170cf9ba4bac1@mail.gmail.com>
 <Pine.LNX.4.56.0603061156140.26994@lion.drogon.net>
 <5d96567b0603060456h5f2c3cc8me790c86b74e1f854@mail.gmail.com>
 <4415F400.5030808@ucolick.org> <17429.64926.100005.904328@cse.unsw.edu.au>
 <Pine.LNX.4.64.0605110758100.25283@twinlark.arctic.org>
 <Pine.LNX.4.64.0605171137350.29929@twinlark.arctic.org>
 <17522.29813.189944.397154@cse.unsw.edu.au> <Pine.LNX.4.64.0605260903270.7952@twinlark.arctic.org>
 <17527.38282.35857.117651@cse.unsw.edu.au> <Pine.LNX.4.64.0605270834240.30550@twinlark.arctic.org>
 <17529.37347.782285.77442@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="131011217-1658932900-1148936192=:30134"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17529.37347.782285.77442@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--131011217-1658932900-1148936192=:30134
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Sun, 28 May 2006, Neil Brown wrote:

> The following patch adds some more tracing to raid5, and might fix a
> subtle bug in ll_rw_blk, though it is an incredible long shot that
> this could be affecting raid5 (if it is, I'll have to assume there is
> another bug somewhere).   It certainly doesn't break ll_rw_blk.
> Whether it actually fixes something I'm not sure.
> 
> If you could try with these on top of the previous patches I'd really
> appreciate it.
> 
> When you read from ..../stripe_cache_active, it should trigger a
> (cryptic) kernel message within the next 15 seconds.  If I could get
> the contents of that file and the kernel messages, that should help.

got the hang again... attached is the dmesg with the cryptic messages.  i 
didn't think to grab the task dump this time though.

hope there's a clue in this one :)  but send me another patch if you need 
more data.

-dean

neemlark:/sys/block/md4/md# cat stripe_cache_size 
256
neemlark:/sys/block/md4/md# cat stripe_cache_active 
251
0 preread
plugged
bitlist=0 delaylist=251
neemlark:/sys/block/md4/md# cat stripe_cache_active 
251
0 preread
plugged
bitlist=0 delaylist=251
neemlark:/sys/block/md4/md# echo 512 >stripe_cache_size 
neemlark:/sys/block/md4/md# cat stripe_cache_active
512
292 preread
not plugged
bitlist=0 delaylist=32
neemlark:/sys/block/md4/md# cat stripe_cache_active
512
292 preread
not plugged
bitlist=0 delaylist=32
neemlark:/sys/block/md4/md# cat stripe_cache_active
445
0 preread
not plugged
bitlist=0 delaylist=73
neemlark:/sys/block/md4/md# cat stripe_cache_active
480
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
413
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
13
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
493
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
487
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
405
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
512
1 preread
not plugged
bitlist=0 delaylist=28
neemlark:/sys/block/md4/md# cat stripe_cache_active
512
84 preread
not plugged
bitlist=0 delaylist=69
neemlark:/sys/block/md4/md# cat stripe_cache_active
512
69 preread
not plugged
bitlist=0 delaylist=56
neemlark:/sys/block/md4/md# cat stripe_cache_active
512
41 preread
not plugged
bitlist=0 delaylist=38
neemlark:/sys/block/md4/md# cat stripe_cache_active
512
10 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
453
3 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
480
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
512
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
512
14 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
477
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
476
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
486
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
480
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
384
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
512
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
387
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
462
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
480
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
448
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
512
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
501
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
476
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
512
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
416
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
386
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
512
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
434
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
406
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
447
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
501
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
448
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
416
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
416
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
380
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
1
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
480
0 preread
not plugged
bitlist=0 delaylist=0
neemlark:/sys/block/md4/md# cat stripe_cache_active
353
0 preread
not plugged
bitlist=0 delaylist=0
--131011217-1658932900-1148936192=:30134
Content-Type: APPLICATION/octet-stream; name=dmesg.gz
Content-Transfer-Encoding: BASE64
Content-Description: 
Content-Disposition: attachment; filename=dmesg.gz

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
grClRaGjc3StZIfopIDAtGl/OsLMpkzAdg24JSPsKZpHyi93zE8xXCG6NJzK
xO4xImnpBsYL6K+0ME436FJ6M5hRUBHJJH2KjsRE0p/mCVpBQK9wirG2EKcS
Wj0NTXgiNMCBfRQgaY1H/HNAQpZpmLsXQRkmHqBpIttCCYqlo2f8LM9yyono
b4ycRmt1mSzkjab0XwZ1oLEiO2UCos0we3WADlQxjckbPY9OI+DNv94V8lcy
OausnWEcPDX7dlOb325q69tNbX+7qZvfburWt5u6/ddPLVsKIyV8l7S9ZTWb
zY5NtxYNciuw9B8yEPIkT8BJxzCaNozPa5qE/yULEWSC1hkByHEnGCLLHloB
GrFYyOC8+v/1lNI4lue0D3K8fCmP9uDhFC5ue/8kVCo4fDB6mPSwcRLAgEf+
B708J3RfmmIZsxDMi6nmR65uvnd180NXNz9+D75XKhUcPmgP5rQH82oP2N49
mL+YCuPTdofZptludfatji7iMfBSy/P2Ls87dHne8Zvw3ZKp4PDBSt6be3nv
vZjAP3ZR/t5F+Ycuyj+e998tmQoOHxXvrb28919MwI9dFN+7KH7oovjxvP9u
yVRw+Kh4b+/lPX8xQXDsooK9iwoOXVRwPO+/WzIVHD4q3jf38j54McHi2EUt
9i5qceiiFsfz/rslU8Hho+J9ay/vFy8mWB67qOXeRS0PXdTyeN5/t2QqOHxU
vG/v5f1SW6NvWPvleYShdw3dgnHv1y/jwZfB8PP0zGy26oAf0/MvdOiGDW2J
NA/ztZvu1ElbXdmeuaHPIMXmJHZlddTO6S+dd0T8nkfAipktEDkVLfh6MWrs
/53i5J93P+f4KcdVw1M9gkSVBQwcHsJ8iSl3sslVicM6zDLkP45gVXTuHM5A
kCVryQG6vXR96J52y1JXGrllERJ95G6+oUoQzUM4eROrBjthNlMYtd3bPZxP
W/0j2WS4cL+q2dQB+sl6TTUFdBN/j8lbk0QkiX2hDX+dWY0A51hTyRjRFka8
OE+Sy5IHe9hOhXZFHWxxODTpUyWtu6ITmreOgpiWuhmdCcvLcnlXXjQgvarE
US9BDBquIfKnokb50Wp34MR4bLc7tbo8jG7XwV+7YMHdpD+dTOqzm9F01psN
6/3r8aQ3qw/7k/pg3PtN48woK6BObmowubk+xRa44rksshtIQauDRVcZRmNl
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
OpOqpWnnHsmQRJ69uB1PyFUW0ZqKD7QsijDGMS+j1IqO7EllUE5XoXIMeSIe
DAajNA1YXRf/F8ITNN+2a/DS/OaynQaTon5d48vyHOBcK3BUuq47+13XnTKz
uz+z2xhG00yd4rnn1aMfzdSCJ2HjxzzZ9ksbIqWsozDi+GIaO/VrKZPZPDzr
muwyFs0wWstNtMrOBI2/1kUtFYBP9blGh0R5Hk2yhWiyi69lcUjOUfmMlL8h
/rLlc8vOqZ0PMjMm0TJ3xZu7XfFW3RVv7XLFm/td8eZBrni7bW+74u29nnhn
tyPezPs08q2dvRrbtV5Je1evuPDefo240AE967V72z07YI/BPtnZNXpg3jm3
6prIGxLTcDgidrc7N6nP4LT+c1b/+VD/GdR/+vns07tVHUKw2OOSFMsxmeoh
VDtM5ovcD6/kdl/knr2S23mRe/pKbvtF7skrua1SQ+UxNj6fq3ZJT/NU0MgX
XBXJ1UIuNW5NZjqFzHTyJ9Ocy8UsSgguqVW3F4N+RxkKZNeSiqbcXkO0Wi2R
+F5HrPmfqc8XuegBPRaRR2sMqstTRzry9taSJ0WyXUueFslOLXlWJLu15AeW
Mvcg0bbstlV/ba390t3bLd3ue3bQym+gueMb+J4ttuG3A/EzVar4xdVH1a/8
wgiZZcl8vMq4s9SpBTtmOXA3mQU6uiBfKRIOObJvvKriMIp6f+SoHnEjQxqB
ZRBm1SnyBmPVUvXpqppKeps++KGv4oEXAVlAZU41glVWT+d9/zhScRKD4Lk+
kHqEScvEzrvG9MJXbXd6p+5Jt/co0jXJAdWZ30DDFVsGX+oz55dj47Us1YQw
Sz0rD/j2isK7tpjW+ed1lEmWzE+DK6GsYTIz72KhNptuxnEqrtnF0F/Fi+B5
f2SC2VhEXnX5BzXuSU424gM3jA2xtEFLjq5ecqjFR7YK+dId3j/Qtl8eby9+
o+FZRDP/G26QNkyiMV8TkwX8znCgWBRnYvjD6HLY15uqjYEOiea8j+E09UVz
Um3mXanNPHr24zw5X5IO8410PTb84MhofLoe9ovg8faTTNqL+bhNNbSfXA4e
pnZtWOHx7SuU9clVL2ogSuar88NRsslrKu8fOjVbWmDELGFTMuZQJr+h54HE
XY2GCppJ0uKKKG3+xmqPs7yCKODvp5criDPzuWOJP7QBeksqZSOGQfBIwhqr
8fnAmcWfr1Wk/nA9JtXzUabZtSSR9NWRCko2O1Rc+SmnKp1UP19rI9aShHgV
qs0brdN9kaxoWkmpn1m8w0CNOxbj32MyyDipyMSXDqkvI19NwCPDilzIJJEb
pcXUF5qU5nK1FKPZSiaS3pPAH6kxru4N0StLT4vn98oWbZNmnWhjRYvJUj6r
aqr7eeYcZTzgO7lCfz336X1r8oUM7DNZ8rIje5DqGoCqUq1l68/efgYvQvIQ
x2MtzVJfS8afLufUPDF7J3xFkoqeMvaMlMVJZm2k/nYBUxdw7NpkbFX1BTng
4Y7zzuYe/oj/ZQG799YS3dO3luBDSW+c7Te3ynpzz51/32RYLmT2P1bA3FUA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgawTYSQEAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAD42q5PRAEUQIF/ssBfdige0ZPCAAA=

--131011217-1658932900-1148936192=:30134--
