From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Root Drive Mirroring and LVM.
Date: Wed, 4 Feb 2004 17:32:01 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0402041726350.20232-100000@coffee.psychology.mcmaster.ca>
References: <20040204122317.K27780@forte.austin.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040204122317.K27780@forte.austin.ibm.com>
To: linas@austin.ibm.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> So what's wrong with autodetect, again?

my guess is: in-kernel autodetect is the problem.  
out-of-kernel detection can be much smarter, 
and can be more easily tested/replaced.


