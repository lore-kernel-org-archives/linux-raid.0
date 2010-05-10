From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: What RAID type and why?
Date: Mon, 10 May 2010 10:20:48 -0500
Message-ID: <20100510152048.GA12411@septictank.raw-sewage.fake>
References: <5bdc1c8b1003061402n1281b64es9fa597b8bc714bd5@mail.gmail.com> <87f94c371003061433x404a8c2fgcb61f817af6ecb1@mail.gmail.com> <5bdc1c8b1003061505g6b310f6ct6795b9180c2e6adf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5bdc1c8b1003061505g6b310f6ct6795b9180c2e6adf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Mar 06, 2010 at 03:05:46PM -0800, Mark Knecht wrote:
> On Sat, Mar 6, 2010 at 2:33 PM, Greg Freemyer <greg.freemyer@gmail.com> wrote:
> > You haven't said what kind of i/o rates you expect, nor how much
> > storage you need.
> 
> Good points. I guess I was assuming I'd want 1TB storage and I'd
> buy 3/5/6 1TB drives to get it. Honestly I probably don't need
> anything close to that. My weekly backups of stock data run about
> 1GB to 1TB should hold me for quite awhile I think.

Where are you sourcing the stock data?  1GB/week seems awful low.
You must be getting top of book only?

We get real-time full depth stock data.  NYSE and Nasdaq data are
each about 100 GB/month, compressed.

Just something to keep in mind if you ever start working with
full-depth feeds.

Also: for backups, you might want to consider par2.  You can use it
to create a specified amount of parity data for each file or group
of files.  Useful in the case of media errors.
