From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID performance - new kernel results
Date: Tue, 16 Apr 2013 16:43:01 -0500
Message-ID: <516DC5E5.4080401@hardwarefreak.com>
References: <20372204.0.1366140527266.JavaMail.root@zimbra>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20372204.0.1366140527266.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org, Adam Goryachev <mailinglists@websitemanagers.com.au>
List-Id: linux-raid.ids

On 4/16/2013 2:28 PM, Roy Sigurd Karlsbakk wrote:

> Switches (unlike bridges) do not use store-and-forward. They use cut-through...

This is incorrect Roy.  The default forwarding mode of all IEEE 802.3
compliant switches is store and forward.  All unmanaged switches use
this forwarding mode.  Cut-through is an optimization and is optional
only on managed switches.

And these aren't the only two forwarding modes in managed switches
today.  Switch routers do layer 3 as well as 2 forwarding, and switches
offering VLANs, QOS, and other features use different forwarding methods
still.  But TTBOMK, all vendors' managed switches default to store and
forward, as that is the IEEE 802.3 standard.

-- 
Stan



