From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Mon, 22 Apr 2013 21:59:27 -0500
Message-ID: <5175F90F.6060206@hardwarefreak.com>
References: <5171CBF9.9020701@redhost.ro> <CAH3kUhEaZGON=fAyVMZOz5fH_DcfKv=hCa96UCeK4pN7k81c_Q@mail.gmail.com> <51725458.7020109@redhost.ro> <CAH3kUhHxBiqugFQm=PPJNNe9jOdKy0etUjQNsoDz_LJNUCLCCQ@mail.gmail.com> <51732422.1050109@redhost.ro> <5173536C.2040108@hardwarefreak.com> <CAGA4a+EMvLJMqufWjfmze9FZ_sDRBE0SCbOe0UYXRNOLU=DUTw@mail.gmail.com> <51743F14.7020404@hardwarefreak.com> <CAGA4a+Fsrum9vrtWbeKP4jWfT3JAAMK4Ci1HU6A2cMez1mwttw@mail.gmail.com> <517488B7.9030505@hardwarefreak.com> <CAGA4a+HS1EkQ0N1J0He25sWYeL6dhACO=zkVB6jSevZUUuOFBQ@mail.gmail.com> <21ba656fc34d77a018772f603ba5b75f@redhost.ro> <CAGA4a+HQGbtBo9wCQ_hbGdd0_==hmTx_Tw8UKw0PzvNcv-76og@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGA4a+HQGbtBo9wCQ_hbGdd0_==hmTx_Tw8UKw0PzvNcv-76og@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tommy Apel <tommyapeldk@gmail.com>
Cc: Andrei Banu <andrei.banu@redhost.ro>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/22/2013 7:02 AM, Tommy Apel wrote:
> Yes it can be run as it is, it will write to the file given by --filename=
> 
> well from what I make of it so far I wouldn't rule out the bad device
> part but at the same time there could be other things involved
> although I don't belive it to be the md part
> 
> Stan> do you know anything about the state of ext4 on centos 6.x ?

Enough to assume it's not part of the problem here.  Andrei's hdparm
below the filesystem layer throughput is bouncing up/down by ~100MB/s
depending on when he runs it.

If he's using LVM and has active snapshots that would definitely cause
some extra load, but in that case given his 3 RAID1 pairs it should
affect both drives equally.  And that's not what we're seeing.

I hope my last post gets him closer to identifying the problem.  The
perf top and iotop data doing $bigfile copy should be instructive.

-- 
Stan

