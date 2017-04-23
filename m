From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recover array after I panicked
Date: Sun, 23 Apr 2017 16:36:40 +0200
Message-ID: <20170423143640.GA12093@metamorpher.de>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <20170423101639.GA4471@metamorpher.de>
 <37269c2b-1788-a0b6-6d91-84c6b6bdd16c@powerlamerz.org>
 <20170423104606.GA4603@metamorpher.de>
 <754209bb-9990-2a36-2233-d7d1273c8e37@powerlamerz.org>
 <20170423131605.GA9955@metamorpher.de>
 <9fcdece2-68b7-8e5b-5995-caf15af18bf3@powerlamerz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9fcdece2-68b7-8e5b-5995-caf15af18bf3@powerlamerz.org>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Dahlstr=F6m?= <risca@powerlamerz.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 23, 2017 at 03:49:16PM +0200, Patrik Dahlström wrote:
> > Again, you'd do this with overlays only...
> I did
> $ mdadm --create /dev/md1 --assume-clean --data-offset=128M --level=5 --raid-devices=5 /dev/mapper/sd[abdce]
> $ dmesg | tail

Hi,

the shell globbing style [abdce] actually expands alphabetically,
you probably have to write {a,b,d,c,e} instead.

$ echo [edcba]
a b c d e
$ echo {e,d,c,b,a}
e d c b a

Use 'dmsetup ls' to make sense of the dm-XX (253:XX) numbers.

Regards
Andreas Klauer
