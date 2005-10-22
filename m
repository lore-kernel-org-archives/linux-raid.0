From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: Re: [PATCH] Online RAID-5 resizing
Date: Sat, 22 Oct 2005 15:45:23 +0200
Message-ID: <20051022134522.GA842@samfundet.no>
References: <20050920143346.GA5777@uio.no> <17200.9302.242957.23189@cse.unsw.edu.au> <20050920153622.GA14287@uio.no> <17202.55529.310871.877019@cse.unsw.edu.au> <20050924014412.GA19832@uio.no> <17221.59105.846162.739316@cse.unsw.edu.au> <20051014194621.GA31390@uio.no> <17234.55921.769147.227160@cse.unsw.edu.au> <20051019231830.GA18894@samfundet.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051019231830.GA18894@samfundet.no>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 20, 2005 at 01:18:30AM +0200, Steinar H. Gunderson wrote:
> Any progress?

Still nothing. I'm at the point now where I'll just let it lie -- there's
been zero real feedback since the very first patch, and it's really not
getting anywhere soon. Versions 05 and 06 of the patch are broken, BTW; the
delay code needs to go back in for cases like expanding 3 -> 4 disks, but it
seems to interfere with the code for not expanding over active stripes, so
something must be done. Oh well, I have other things to do...

/* Steinar */
-- 
Homepage: http://www.sesse.net/

