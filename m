From: Thomas Andrews <tandrews@grok.co.za>
Subject: Re: One partition degraded after every reboot
Date: Fri, 9 Apr 2004 15:39:49 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040409133949.GA10900@gaspode.nextlink.co.za>
References: <20040326154125.GN1950@gaspode.nextlink.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040326154125.GN1950@gaspode.nextlink.co.za>
To: Thomas Andrews <tandrews@grok.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What can cause this to occur after a clean shutdown & reboot:

"md1: former device ide/host2/bus0/target0/lun0/part5 is unavailable, removing from array!"

I have looked in md.c and I can see where it occurs, but I don't
understand the code much.

-Thomas
