From: Nick Bowler <nbowler@elliptictech.com>
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 09:25:45 -0500
Message-ID: <20100217142545.GA12165@emergent.ellipticsemi.com>
References: <201002140251.59668.volkerarmin@googlemail.com>
 <201002162206.32797.volkerarmin@googlemail.com>
 <20100216220020.GA1036@emergent.ellipticsemi.com>
 <201002162318.33950.volkerarmin@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201002162318.33950.volkerarmin@googlemail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23:18 Tue 16 Feb     , Volker Armin Hemmann wrote:
> On Dienstag 16 Februar 2010, Nick Bowler wrote:
> > I put a complete set of recovery tools into my initramfses so that when
> > the system is completely fucked up, I have a kernel that is able to boot
> > until rdinit=/bin/zsh (or /bin/bb, if you prefer) takes over.
> > 
> > This has the added advantage of working when the root filesystem cannot
> > be mounted at all: a scenario which does not seem too far-fetched when
> > the filesystem is located on a raid array.
> 
> and what do you do if you have to boot from a cd/usb stick and need to access 
> the raid?
> 
> Simple with auto assembling. Not so much without.

The same initramfs can be used on a CD or USB stick.  If you were
referring to using someone else's CD or USB stick, then obviously
mdadm will need to be available.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
