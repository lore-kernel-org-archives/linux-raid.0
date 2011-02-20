From: Simon Mcnair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Sun, 20 Feb 2011 19:25:04 +0000
Message-ID: <AANLkTikPFR+G7XvaNxOGrf+bHOAbNGbHtpOu7vWRbiqR@mail.gmail.com>
References: <4D540F6C.6050904@gmail.com>
	<20110215155315.55d35b8e@notabene.brown>
	<4D5A92F3.1090004@turmel.org>
	<4D5BD678.2050200@gmail.com>
	<4D5BE119.7000804@turmel.org>
	<4D5C0E17.3060306@gmail.com>
	<4D5C140F.9010301@turmel.org>
	<4D5C1508.3040308@gmail.com>
	<4D5C15D3.1070608@turmel.org>
	<4D5C167C.7000101@turmel.org>
	<4D5C1CF8.1020507@gmail.com>
	<4D5C1E0B.9060300@turmel.org>
	<4D5C2061.4060106@gmail.com>
	<4D5C2143.3000907@turmel.org>
	<4D5C2260.3020800@gmail.com>
	<4D5C273E.7020609@turmel.org>
	<AANLkTi=RmR5nVnmFLuqK5anHc3WDPxjuYjitT6+5wAqS@mail.gmail.com>
	<4D616218.1060905@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D616218.1060905@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

that's not good :-(

have done the --fail and running fsck at the moment.  IOstat as below:

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
          10.96    0.00    4.01   10.98    0.00   74.05

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
avgrq-sz avgqu-sz   await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00
sda1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00
sda2              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00
sdd            4455.20     0.00  497.80    0.00    19.35     0.00
79.59     1.66    3.34   1.11  55.20
sdd1           4455.20     0.00  497.80    0.00    19.35     0.00
79.59     1.66    3.34   1.11  55.20
sde            4454.20     0.00  498.60    0.00    19.35     0.00
79.47     1.63    3.26   1.13  56.20
sde1           4454.20     0.00  498.60    0.00    19.35     0.00
79.47     1.63    3.26   1.13  56.20
sdf            4311.60     0.00  615.60    0.00    19.33     0.00
64.31     1.22    1.98   0.60  37.20
sdf1           4311.60     0.00  615.60    0.00    19.33     0.00
64.31     1.22    1.98   0.60  37.20
sdg            4262.60     0.00  659.60    0.00    19.35     0.00
60.08     1.83    2.77   0.79  52.20
sdg1           4262.60     0.00  659.60    0.00    19.35     0.00
60.08     1.83    2.77   0.79  52.20
sdh            4242.20     0.00  665.80    0.00    19.36     0.00
59.54     1.67    2.51   0.63  42.00
sdh1           4242.20     0.00  665.80    0.00    19.36     0.00
59.54     1.67    2.51   0.63  42.00
sdi               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00
sdi1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00
sdj            4382.00     0.00  567.20    0.00    19.34     0.00
69.82     1.35    2.38   0.74  42.20
sdj1           4382.00     0.00  567.20    0.00    19.34     0.00
69.82     1.35    2.38   0.74  42.20
sdk            4341.40     0.00  605.60    0.00    19.34     0.00
65.42     1.71    2.82   0.89  53.80
sdk1           4341.40     0.00  605.60    0.00    19.34     0.00
65.42     1.71    2.82   0.89  53.80
sdl            4368.20     0.00  579.20    0.00    19.33     0.00
68.36     1.78    3.07   0.99  57.60
sdl1           4368.20     0.00  579.20    0.00    19.33     0.00
68.36     1.78    3.07   0.99  57.60
sdm            4351.00     0.00  591.40    0.00    19.32     0.00
66.92     2.17    3.68   1.09  64.60
sdm1           4351.00     0.00  591.40    0.00    19.32     0.00
66.92     2.17    3.68   1.09  64.60
dm-0              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00
dm-1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00
dm-2              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00
md0               0.00     0.00 24808.00    0.00    96.91     0.00
8.00     0.00    0.00   0.00   0.00
dm-3              0.00     0.00 5735.60    0.00    22.40     0.00
8.00    26.08    4.55   0.17  99.20
sdr               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00
sdr1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00
sds               0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00
sds1              0.00     0.00    0.00    0.00     0.00     0.00
0.00     0.00    0.00   0.00   0.00

Simon

On 20 February 2011 18:48, Phil Turmel <philip@turmel.org> wrote:
> On 02/20/2011 12:03 PM, Simon Mcnair wrote:
>> Hi Phil,
>>
>> Is this fsck (fsck.ext4 -n -b 32768 /dev/mapper/lvm--raid-RAID
>>> fsck.txt) as bad as it looks ? :-(
>
> It's bad. =A0Either the original sdd has a lot more corruption than I=
 expected, or the 3ware spread corruption over all the drives.
>
> If the former, failing it out of the array might help. =A0If the latt=
er, your data is likely toast. =A0Some identifiable data is being found=
, based on the used vs. free block/inode/directory counts in that repor=
t. =A0That's good.
>
> I suggest you do "mdadm /dev/md0 --fail /dev/sdi1" and repeat the "fs=
ck -n" as above.
>
> (It'll be noticably slower, as it'll be using parity to reconstruct 1=
 out every 9 chunks.)
>
> If it the fsck results improve, or stay the same, proceed to "fsck -y=
", and we'll see.
>
> Wouldn't hurt to run "iostat -xm 5" in another terminal during the fs=
ck to see what kind of performance that array is getting.
>
> Phil
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
