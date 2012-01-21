From: Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: Preventative replacement of active RAID1 disks
Date: Sat, 21 Jan 2012 18:09:49 +0200
Message-ID: <4F1AE34D.8030209@iki.fi>
References: <4F16FB90.5000905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F16FB90.5000905@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18.01.2012 19:04, Jan Ceuleers wrote:
> List,
> 
> I have two 2-partition RAID1 sets, each with a spare. The SMART info for
> both active disks suggests that I should replace them. Both of them. I
> based this on the Seek_Error_Rate in the smartctl -a output (below).

[...]
> Model Family:     Seagate Barracuda 7200.12 family
> Device Model:     ST3500418AS
>   7 Seek_Error_Rate         0x000f   079   060   030    Pre-fail 
> Always       -       93484948
[...]
> Model Family:     Seagate Barracuda 7200.12 family
> Device Model:     ST3500418AS
>   7 Seek_Error_Rate         0x000f   079   060   030    Pre-fail 
> Always       -       97304022
[...]

I don't think these indicate any issue with the drives, all of my
Seagate disks have random big values in that attribute (from 11717390 to
103488378525).

-- 
Anssi Hannula
