From: Derek Vadala <derek@cynicism.com>
Subject: Re: Using mdadm.conf to create arrays
Date: Fri, 7 Mar 2003 11:14:34 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030307161434.088CB3B828@jaded.cynicism.com>
References: <8075D5C3061B9441944E137377645118012E86@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8075D5C3061B9441944E137377645118012E86@cinshrexc03.shermfin.com>
To: linux-raid@vger.kernel.org
Cc: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
List-Id: linux-raid.ids

On Fri, 7 Mar 2003, Rechenberg, Andrew wrote:

> With raidtools I can create the conf file and then do an 'mkraid
> /dev/md[0-9]' and that will create those ten arrays.  Is there a way to
> accomplish something similar with mdadm and mdadm.conf?

I don't think mdadm has the functionality you're looking for. Maybe I'm
missing something, but why not just create a shell script to create the
arrays? Surely some substitutions and regex's in vi to build mdadm -C
commands would be simpler than creating a config file. Perhaps if you
explained what you're trying to do a little bit more...

--
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek


