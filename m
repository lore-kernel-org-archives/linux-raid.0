From: rabbit@rabbit.us (Peter Rabbitson)
Subject: Re: RAID10 Resync fails with specific chunk size and drive sizes (reproducible)
Date: Tue, 20 Feb 2007 08:44:48 -0500
Message-ID: <20070220134448.GA2883@rabbit.us>
References: <20070220113549.GB5584@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070220113549.GB5584@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After I sent the message I received the 6 patches from Neil Brown. I 
applied the first one (Fix Raid10 recovery problem) and it seems to be 
taking care of the issue I am describing. Probably due to the rounding 
fixes.

Thanks 

