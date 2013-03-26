From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID-10 with mixed block size HDDs
Date: Tue, 26 Mar 2013 20:05:51 +0100
Message-ID: <20130326190551.GA2277@lazy.lzy>
References: <20130325180458.GA4833@lazy.lzy>
 <0619B2C8-EEFF-4B58-BF5E-A4ACA7A501AE@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0619B2C8-EEFF-4B58-BF5E-A4ACA7A501AE@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 25, 2013 at 05:09:00PM -0600, Chris Murphy wrote:
> 
> On Mar 25, 2013, at 12:04 PM, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:
> 
> > Hi all,
> > 
> > I've a two disk RAID-10 (far 2, I guess).
> > One HDD seems to be going to the HDD heaven,
> > so I'm planning to change it.
> > 
> > The most convenient HDD I found has 4K sectors,
> > while the actual ones have 512 byte sectors.
> 
> It is a 4Kn drive, or a 512e drive? If it's 512e, as long as you add the whole disk or ensure alignment, it's OK. For 4Kn drives, that may be a problem. But so far I've only seen 4Kn drives as large 3+TB external USB.

Hi Chris,

thanks for the answer.

Reading the specs it seems it can emulate the 512,
so it should be a 512e.

Thanks again,

bye,

pg

> 
> 
> Chris Murphy

-- 

piergiorgio
