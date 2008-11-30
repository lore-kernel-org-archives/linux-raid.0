From: Luca Berra <bluca@comedia.it>
Subject: Re: array always resyncs on boot
Date: Sun, 30 Nov 2008 09:07:53 +0100
Message-ID: <20081130080752.GA19919@maude.comedia.it>
References: <4931B2C5.5060403@openhardware.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4931B2C5.5060403@openhardware.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Nov 29, 2008 at 04:23:17PM -0500, Tom Walsh wrote:
> <sigh> I need help!

i'll try :(
> I've overhauled the software, replaced the operating system
> innumerable times with several Mandriva distros: 2008, 2008.1, 2009.
> Removed the Mandriva kernel and compiled a stock 2.6.27.7 from
> ftp.kernel.org.  Ran the Seagate SeaTools on all four drives, no
> errors.  Ran the Western Digital Date Lifeguard on the two drives, no
> errors.  Changed from raid5 to raid10, still resyncs on boot.

https://qa.mandriva.com/show_bug.cgi?id=40023

read the whole of it.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
