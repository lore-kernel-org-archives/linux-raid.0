From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 16:45:24 +0200
Message-ID: <02a6e7e8-f6cc-eb60-7298-4211c26fd2fd@powerlamerz.org>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <20170423101639.GA4471@metamorpher.de>
 <37269c2b-1788-a0b6-6d91-84c6b6bdd16c@powerlamerz.org>
 <20170423104606.GA4603@metamorpher.de>
 <754209bb-9990-2a36-2233-d7d1273c8e37@powerlamerz.org>
 <20170423131605.GA9955@metamorpher.de>
 <9fcdece2-68b7-8e5b-5995-caf15af18bf3@powerlamerz.org>
 <20170423143640.GA12093@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170423143640.GA12093@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/23/2017 04:36 PM, Andreas Klauer wrote:
> On Sun, Apr 23, 2017 at 03:49:16PM +0200, Patrik Dahlström wrote:
>>> Again, you'd do this with overlays only...
>> I did
>> $ mdadm --create /dev/md1 --assume-clean --data-offset=128M --level=5 --raid-devices=5 /dev/mapper/sd[abdce]
>> $ dmesg | tail
> 
> Hi,
> 
> the shell globbing style [abdce] actually expands alphabetically,
> you probably have to write {a,b,d,c,e} instead.
I spelled it out for every device but no change in the result I'm
afraid. It still won't mount it, nor will fsck recognize it.

Doesn't the triggered reshape pose an issue here? It went ~16 % through.

// Patrik
