From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 15:49:19 -0700
Message-ID: <1CEFA702-4512-40C1-ABE4-0FF7F42D9F44@colorremedies.com>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy> <6D287BCE-96EB-4F91-AC5A-34CD7AD2C68D@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6D287BCE-96EB-4F91-AC5A-34CD7AD2C68D@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 28, 2013, at 3:47 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> I think regression is going to be needed to find it. Hopefully the problem is restricted to parity computation and data chunks aren't affected; however if a URE occurs in a data chunk, it could be reconstructed incorrectly from bad parity so it's obviously still a big problem.

Actually it also needs to be reproduced as well. Wolfgang, the arrays were created/running under what version of mdadm and kernel the last time you did a check and there were no problems?

And now you're on Fedora 18, but the problem appeared with what version of mdadm and kernel?

Chris Murphy