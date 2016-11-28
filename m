From: Avi Kivity <avi@scylladb.com>
Subject: Re: raid0 vs. mkfs
Date: Mon, 28 Nov 2016 09:33:41 +0200
Message-ID: <8ee321ba-0576-27a6-079a-e4a4fdf0360b@scylladb.com>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
 <CAJCQCtR+PnJXq9k37V1pXVO4UmW0dbhvAZYo=Pius2eCz9X_kg@mail.gmail.com>
 <9ce71838-0a1d-e4d8-5786-9ab0422688af@scylladb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9ce71838-0a1d-e4d8-5786-9ab0422688af@scylladb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 11/28/2016 09:28 AM, Avi Kivity wrote:
> 259,1   10     1140     0.380238333  4801  I   D 3238079488 + 1024 
> [mkfs.xfs]
> 259,1   10     1141     0.380252580  2307  D   D 3238079488 + 1024 
> [kworker/10:1H]
> 259,1    2      173     0.380260605     0  C   D 3218709504 + 1024 [0]
> 259,1   10     1142     0.380283800  4801  Q   D 3238080512 + 1024 
> [mkfs.xfs]
> 259,1   10     1143     0.380284158  4801  G   D 3238080512 + 1024 
> [mkfs.xfs]
> 259,1   10     1144     0.380285150  4801  I   D 3238080512 + 1024 
> [mkfs.xfs]
> 259,1   10     1145     0.380297127  2307  D   D 3238080512 + 1024 
> [kworker/10:1H]
> 259,1   10     1146     0.380324340  4801  Q   D 3238081536 + 1024 
> [mkfs.xfs]
> 259,1   10     1147     0.380324648  4801  G   D 3238081536 + 1024 
> [mkfs.xfs]
> 259,1   10     1148     0.380325663  4801  I   D 3238081536 + 1024 
> [mkfs.xfs]
> 259,1    2      174     0.380328083     0  C   D 3218710528 + 1024 [0]
>
>
> So we see these one-megabyte requests; moreover, they are issued 
> sequentially.
>

Correction, they are issued in parallel, but not merged.  The "C" 
entries correspond to requests issued far in the past.

