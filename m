From: Joe Pruett <joey@q7.com>
Subject: Re: large await discrepancies
Date: Thu, 12 Dec 2002 07:30:59 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0212120727480.2430-100000@q7.q7.com>
References: <Pine.LNX.4.44.0212100758160.29301-100000@q7.q7.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0212100758160.29301-100000@q7.q7.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

well, going to a different second controller didn't help any.  immediately 
i could see the second drive light going on and staying on for seconds at 
a time with the system load going up to 30-40.  so i have now broken the 
mirror and things have been just fine since then.  the highest load has 
been maybe 5 since then.  so obviously something is up with mirroring, or 
that second drive.  this is under stock redhat 7.2 with all patches.  are 
there known issues with mirroring in this release?  i have a similar setup 
at home, but running 7.1 and not under as heavy a load, but the iostat 
numbers look just fine there.

