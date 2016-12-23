From: "Marc Roos" <M.Roos@f1-outsourcing.eu>
Subject: Raid5 performance issue
Date: Fri, 23 Dec 2016 14:43:03 +0100
Message-ID: <36140.198846306$1505296064@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I have grown a raid5 over the years with drives and resized partitions, 
now I have upgraded to centos7 (from centos5). And I have the impression 
the speed is not what it used to be. 

Can this be because of some missalignment? How can this be verified?


If I monitor the individual disks with dstat it reads the raid drives at 
very low speeds

dd if=/dev/md21 of=/dev/null bs=1M count=1500 iflag=direct
1500+0 records in
1500+0 records out
1572864000 bytes (1.6 GB) copied, 19.5879 s, 80.3 MB/s


   0     0 :   0     0 :   0     0 :   0     0 :   0     0 :   0     0 : 
  0     0
   0     0 :   0     0 :   0     0 :   0     0 :   0     0 :   0     0 : 
  0     0
   0     0 :   0     0 :   0     0 :   0     0 :   0     0 :   0     0 : 
  0     0
 256k    0 : 320k    0 : 320k    0 : 192k    0 : 256k    0 : 320k    0 : 
256k    0
4672k    0 :4672k    0 :4672k    0 :4800k    0 :4672k    0 :4672k    0 
:4736k    0
  11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 : 
 11M    0
  10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 : 
 10M    0
  10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 : 
 10M    0
  13M    0 :  13M    0 :  13M    0 :  13M    0 :  13M    0 :  13M    0 : 
 13M    0
  10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 : 
 10M    0
  11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 : 
 11M    0
  19M    0 :  19M    0 :  19M    0 :  19M    0 :  19M    0 :  19M    0 : 
 19M    0
9984k    0 :9792k    0 :9792k    0 :9792k    0 :9984k    0 :9984k    0 
:9856k    0
  13M    0 :  13M    0 :  13M    0 :  13M    0 :  13M    0 :  13M    0 : 
 13M    0
  11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 : 
 11M    0
  12M    0 :  12M    0 :  12M    0 :  12M    0 :  12M    0 :  12M    0 : 
 12M    0
7872k    0 :7744k    0 :7808k    0 :7744k    0 :7936k    0 :7744k    0 
:7744k    0
  11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 :  11M    0 : 
 11M    0
  19M    0 :  19M    0 :  19M    0 :  19M    0 :  19M    0 :  19M    0 : 
 19M    0
7488k    0 :7360k    0 :7296k    0 :7360k    0 :7296k    0 :7296k    0 
:7296k    0
  10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 :  10M    0 : 
 10M    0
  14M    0 :  14M    0 :  14M    0 :  14M    0 :  14M    0 :  14M    0 : 
 14M    0
9472k    0 :9536k    0 :9536k    0 :9536k    0 :9472k    0 :9536k    0 
:9472k    0
   0     0 :   0     0 :   0     0 :   0     0 :   0     0 :   0     0 : 
  0     0

When I test the individual disks with

for disk in sdm sdl sdi sde sdk sdf sdd;do `dd if=/dev/$disk 
of=/dev/null bs=1M count=1500 iflag=direct &`  ;done

[root@san2 ~]# 1500+0 records in
1500+0 records out
1572864000 bytes (1.6 GB) copied, 8.96022 s, 176 MB/s
1500+0 records in
1500+0 records out
1572864000 bytes (1.6 GB) copied, 9.59289 s, 164 MB/s
1500+0 records in
1500+0 records out
1572864000 bytes (1.6 GB) copied, 10.0863 s, 156 MB/s
1500+0 records in
1500+0 records out
1572864000 bytes (1.6 GB) copied, 10.5833 s, 149 MB/s
1500+0 records in
1500+0 records out
1572864000 bytes (1.6 GB) copied, 10.6084 s, 148 MB/s
1500+0 records in
1500+0 records out
1572864000 bytes (1.6 GB) copied, 11.0205 s, 143 MB/s
1500+0 records in
1500+0 records out
1572864000 bytes (1.6 GB) copied, 11.3199 s, 139 MB/s



  0     0 :   0     0 :   0     0 :   0     0 :   0     0 :   0     0 :  
 0     0
   0     0 :   0     0 :   0     0 :   0     0 :   0     0 :   0     0 : 
  0     0
4096k    0 :5120k    0 :  32M    0 : 512k    0 :  29M    0 :  35M    0 
:5120k    0
  62M    0 :  51M    0 : 157M    0 : 145M    0 : 144M    0 : 153M    0 : 
 38M    0
 153M    0 : 148M    0 : 158M    0 : 174M    0 : 135M    0 : 151M    0 : 
150M    0
 152M    0 : 144M    0 : 154M    0 : 179M    0 : 150M    0 : 146M    0 : 
149M    0
 149M    0 : 147M    0 : 155M    0 : 186M    0 : 148M    0 : 155M    0 : 
157M    0
 156M    0 : 128M    0 : 154M    0 : 188M    0 : 136M    0 : 153M    0 : 
155M    0
 159M    0 : 136M    0 : 157M    0 : 206M    0 : 147M    0 : 155M    0 : 
151M    0
 153M    0 : 147M    0 : 162M    0 : 153M    0 : 144M    0 : 127M    0 : 
147M    0
 153M    0 : 138M    0 : 159M    0 : 153M    0 : 134M    0 : 145M    0 : 
146M    0
 147M    0 : 144M    0 : 154M    0 : 116M    0 : 144M    0 : 153M    0 : 
143M    0
 154M    0 : 150M    0 :  60M    0 :   0     0 : 141M    0 : 131M    0 : 
153M    0
  61M    0 : 147M    0 :   0     0 :   0     0 :  51M    0 :   0     0 : 
109M    0
   0     0 :  17M    0 :   0     0 :   0     0 :   0     0 :   0     0 : 
  0     0

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -. 
F1 Outsourcing Development Sp. z o.o.
Poland 

t:  +48 (0)124466845
f:  +48 (0)124466843
e:  marc@f1-outsourcing.eu


