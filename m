From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID5 not being reassembled correctly after device swap
Date: Wed, 04 Jul 2007 09:35:18 -0400
Message-ID: <468BA216.40103@tmr.com>
References: <200707012321.48346.infomails@tronserver.dyndns.org> <200707031916.50502.infomails@tronserver.dyndns.org> <468A98D5.9090206@dgreaves.com> <200707032129.10787.infomails@tronserver.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200707032129.10787.infomails@tronserver.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Frotscher <infomails@tronserver.dyndns.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Frotscher wrote:
> I forgot, in case it's of any help. 
> mdadm -D gives after reassembly:
>
> [snip]
>
> Any ideas on why the drive keeps being removed?
>   
Do you see anything in dmesg which would indicate an error on the drive? 
And could you share an "fdisk -l" output so we can see what the kernel 
thinks is on the drive? My guess is that for some reason the device is 
being considered unread, has the wrong partition type, or was low level 
formatted on a Monday. Okay, that last is unlikely ;-)

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

