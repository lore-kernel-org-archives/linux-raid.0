From: Harry Mangalam <hjm@tacgi.com>
Subject: Re: Smart and SATA with FC4
Date: Thu, 16 Jun 2005 15:04:36 -0700
Message-ID: <200506161504.36242.hjm@tacgi.com>
References: <42B1A8EB.6060805@ucolick.org> <200506161051.27648.hjm@tacgi.com> <42B1F5D4.3000204@ucolick.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42B1F5D4.3000204@ucolick.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Patrik Jonsson <patrik@ucolick.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm using:
smartmontools release 5.32

so maybe I AM using a patched kernel.  Haven't been able to explicitly find 
anything about it googling for 30s tho.

sorry.

hjm



On Thursday 16 June 2005 2:57 pm, Patrik Jonsson wrote:
> Harry Mangalam wrote:
> >on the unpatched kernel, have you tried forcing the smartctl to see the
> > disks as ATA devices:
> >
> >smartctl -a -d ata /dev/sd[etc]
> >            ^^^^^^
> >Using Ubuntu's 2.6.10-5-amd64-generic (unsure if it has been patched), I
> > was surprised that this worked great, including being able to force long
> > tests to the disks.
>
> yeah, i did try using the -d ata option, but it made no difference. But
> like I said, I don't know if there's also something to do with
> smartmontools. Which version are you using?
>
> /Patrik

-- 
Cheers, Harry
Harry J Mangalam - 949 856 2847 (vox; email for fax) - hjm@tacgi.com 
            <<plain text preferred>>
