From: Clemens Schwaighofer <cs@tequila.co.jp>
Subject: Re: parts -- Re: ext3 journal on software raid (was Re: PROBLEM:
 Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 19 Jan 2005 14:49:00 +0900
Message-ID: <41EDF4CC.2060101@tequila.co.jp>
References: <Pine.LNX.3.96.1050118205122.1423A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1050118205122.1423A-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alvin Oga <aoga@ns.Linux-Consulting.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/19/2005 02:05 PM, Alvin Oga wrote:
> hi ya clemen
> 
> On Wed, 19 Jan 2005, Clemens Schwaighofer wrote:
> 
> 
>>On 01/05/2005 11:44 PM, Alvin Oga wrote:
>>
>>
>>>you're buying bad hardware from bad vendors
>>
>>seriously, thats just wrong. Ever heard of IBM "death"start HDs? Or
>>other stuff? As long as you use IDE hardware you are always close to
>>fail, IDE hardware is done to put much data on cheap disks.
> 
> 
> the "deathstar" ( from thailand to be specific ) disks are the exception
> and the worst of the bunch
> 
> majority of all my dead disks are scsi disks ..
> 	- the so called better scsi is in fact worst probably
> 	because it runs hotter ( spinning faster )
> 	where cooling the case will not help the ball bearings
> 	or cooling the disk controller's chips
> 
> 	( scsi: seagate, ibm, fujitsu, ..
> 	( ide:  seagate, ibm, fujitsu, wd, maxtor, quantum ... 

Since I do SysAdmin as a "get money for it" service I had not a single
SCSI disk die (call it luck). But I saw so many dead IDE disks, that I
never ever will use IDE stuff in a mission critical or any system that
has to run more reliable.
I think SCSI disks are built for longer usage, and the thing "faster ->
hotter" for SCSI disks is bullshit.
IDE disks run also ~7.500 and more.
I have a bunch of 15K SCSI disks in use and the rest is 10K SCSI disks,
they (10K) run since 3.5 years without a problem.

> and most of my ide disks are approaching 8-10 years and no problems
> though most of the cpu's or mb have long since been offline for
> too slow of a cpu  -- most all are in offices or 65F server rooms

well thats another imporant thing. Where are those boxes. If you store
them in an un-airconditioned room, that is in a building with a central
heating, and in a country where you have >2 Months of >30C a day.
Then you just call for a server problem.

> how you build systems does make a difference..
> 	- lots of fans ( at least 2 per ide disk, just in case one dies )
> 	( that is the same as with scsi .. now you can compare )

well, "I", never build a single Server. I buy them from HP, Supermicro,
etc. I am out of the "build all myself" age ...

>>A expensive vendor doesn't help you from crappy HW insealf.
> 
> lots ... 90% f crappy vendors ... 
> 	- bad disk or wrong disks
> 	- bad mb or wrong mb
> 	- bad nic or wrong nic
> 	- or no rma number to return bad parts
> 	- .. on and on ..
> 
> - i buy thru tier1 distributors and don't have any "noticeable" bad parts
>   ( maybe .1% failure ( doa )) over 1,000s of ide disks in the past year
>   or two  and lasts way past its warranty period

still, you are not save of bad parts, you are perhaps more save to get
them replaced with more trustworthy distributors.

- --
[ Clemens Schwaighofer                      -----=====:::::~ ]
[ TBWA\ && TEQUILA\ Japan IT Group                           ]
[                6-17-2 Ginza Chuo-ku, Tokyo 104-0061, JAPAN ]
[ Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343 ]
[ http://www.tequila.co.jp        http://www.tbwajapan.co.jp ]
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFB7fTLjBz/yQjBxz8RAqyRAJ90VF9uAbmyh4bfJaGho/CN/aTyQgCg4aqK
PWGToqzGBLgKHgolF2fqp/Y=
=woCo
-----END PGP SIGNATURE-----
