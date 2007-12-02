From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Reading takes 100% precedence over writes for mdadm+raid5?
Date: Sun, 2 Dec 2007 18:26:45 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712021821290.13428@p34.internal.lan>
References: <Pine.LNX.4.64.0712021807260.10289@p34.internal.lan>
 <18259.15708.870492.17273@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18259.15708.870492.17273@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 3 Dec 2007, Neil Brown wrote:

> On Sunday December 2, jpiszcz@lucidpixels.com wrote:
>>
>> Was curious if when running 10 DD's (which are writing to the RAID 5)
>> fine, no issues, suddenly all go into D-state and let the read/give it
>> 100% priority?
>
> So are you saying that the writes completely stalled while the read
> was progressing?  How exactly did you measure that?
Yes, 100%.

>
> What kernel version are you running.
2.6.23.9

>
>>
>> Is this normal?
>
> It shouldn't be.
>
> NeilBrown
>

I checked again with du -sb while it is writing, it is, just just VERY 
slowly:

Before reading dd:

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  1  3    104  46088      8 7669416    0    0     0 102832 2683 21132  0 34 43 22
  0  2    104  49140      8 7666724    0    0     0 137800 2662 6690  0 30 45 25
  0  4    104  47344      8 7668884    0    0     0 93312 2637 19454  0 22 40 38
  0  6    104  51292      8 7664688    0    0     0 89404 2538 7901  0 18 31 51
  0  1    104  55476      8 7660424    0    0     0 172852 2669 13607  0 39 47 14
  0  3    104  50428      8 7665036    0    0     0 135916 2711 22523  0 27 52 22
  0  5    104  51836      8 7664152    0    0     0 101504 2491 2784  0 18 42 40
  0  5    104 113468      8 7603016    0    0     0 63788 2568 7528  0 24 24 52
  0  2    104  45780      8 7669364    0    0  1116 177604 2617 13521  0 34 33 33

After reading dd launched:

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  2  4    104  45076 2379348 5273588    0    0  7584 17753  548  301  0 17 45 39
  0  5    104  46632 2617352 5043116    0    0 237908     0 2949 2647  0 10 35 54
  1  5    104  45656 2846728 4814900    0    0 229376     0 2768 2360  0 10 36 54
  1  4    104  46128 3104932 4551408    0    0 258308  2748 2918 2559  0 11 36 53
  0  5    104  43804 3338248 4323996    0    0 233212     0 2815 2631  0 10 33 57
  0  5    104  46580 3534856 4125848    0    0 196608     0 2736 2273  0  9 36 55
  0  5    104  46164 3797000 3862936    0    0 262144  1396 2900 2834  0 11 37 51
  1  4    104  46076 4026376 3633740    0    0 229376     0 2978 2586  0 11 37 53
  0  5    104  46252 4288520 3371724    0    0 262144     0 2878 2316  0 11 37 53
  0  5    104  46520 4517896 3142376    0    0 229440     0 2912 2406  0 10 35 56
  0  5    104  47408 4747272 2913156    0    0 229376     0 2903 2619  0 10 36 54
  1  4    104  46800 4976648 2683560    0    0 229376     0 2726 2346  0 10 37 53
  0  5    104  45284 5206024 2456248    0    0 229376     0 2856 2482  0 10 36 54
  0  5    104  46524 5468168 2192136    0    0 262144     0 2956 2750  0 11 36 54
  0  5    104  47284 5697544 1962556    0    0 229376     0 2894 2589  0 10 37 53

Takes awhile before it writes anything..

l1:/r# du -sb .
1250921771135   .
l1:/r# du -sb .
1250921771135   .
l1:/r# du -sb .
1250921771135   .
l1:/r# du -sb .
1250921771135   .
l1:/r# du -sb .
1250921771135   .
l1:/r# du -sb .
1250921771135   .
l1:/r# du -sb .
1250921771135   .
l1:/r# du -sb .
1250921771135   .
l1:/r# du -sb .
1250921771135   .
l1:/r# du -sb .
1250921771135   .
l1:/r# du -sb .
1250921771135   .
l1:/r#

.. 5 minutes later ..

l1:/r# du -sb .
1251764138111   .
l1:/r#

l1:/r# du -sb .
1251885887615   .
l1:/r#

l1:/r# ps auxww | grep dd
root      2206  4.5  0.0  10356  1672 ?        D    Dec02  11:46 dd if /dev/zero of 1.out bs 1M
root      2207  4.5  0.0  10356  1672 ?        D    Dec02  11:47 dd if /dev/zero of 2.out bs 1M
root      2208  4.4  0.0  10356  1676 ?        D    Dec02  11:42 dd if /dev/zero of 3.out bs 1M
root      2209  4.5  0.0  10356  1676 ?        D    Dec02  11:53 dd if /dev/zero of 4.out bs 1M
root      2210  4.4  0.0  10356  1672 ?        D    Dec02  11:43 dd if /dev/zero of 5.out bs 1M
root      2211  4.4  0.0  10356  1676 ?        D    Dec02  11:43 dd if /dev/zero of 6.out bs 1M
root      2212  4.4  0.0  10356  1676 ?        D    Dec02  11:38 dd if /dev/zero of 7.out bs 1M
root      2213  4.5  0.0  10356  1672 ?        D    Dec02  11:50 dd if /dev/zero of 8.out bs 1M
root      2214  4.5  0.0  10356  1672 ?        D    Dec02  11:47 dd if /dev/zero of 9.out bs 1M
root      2215  4.4  0.0  10356  1676 ?        D    Dec02  11:44 dd if /dev/zero of 10.out bs 1M
root      3251 25.0  0.0  10356  1676 pts/2    D    02:21   0:14 dd if /dev/md3 of /dev/null bs 1M
root      3282  0.0  0.0   5172   780 pts/2    S+   02:22   0:00 grep dd
l1:/r#

HP raid controllers (CCISS) allow a pct(%) utilization for read/write, 
does Linux/mdadm's implementation offer this anywhere in a sys or proc 
tunable?

Justin.

