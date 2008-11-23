From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Why does the md/raid subsystem does not remap bad sectors in a raid array?
Date: Sat, 22 Nov 2008 18:13:35 -0600
Message-ID: <cccedfc60811221613x5f58e149ra13e4fc646e11212@mail.gmail.com>
References: <alpine.DEB.1.10.0811221859210.14817@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811221859210.14817@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

There are a few reasons but my guess is this: md tries to use the
entire available storage (of the smallest element) in a given set of
devices, which means there is no room for remappery.

However, if MD could be told to set aside some percentage of this
value, or some fixed amount (like, say, 10MB) then the *possibility*
of remapping blocks becomes possible.

However, to add this functionality one would have to consider the following:

1. how much to set aside?
2. where? beginning, end, middle, staggered in chunks?
3. how to tell MD that block A maps to block B on device C? Should it
be done as an exception list (all blocks not in list X refer to their
actual block, otherwise they refer to a redirected block)? or as a
direct map (or something else)?

Perhaps an alternative would be to add a new block layer which takes
an existing block device X and exposes a new, automatic block
remapper-y block device Y (bad reads might continue to return errors
but writes to a previous bad read might go to a new block and so would
subsequent reads) and so on.

Perhaps the easiest way to test this would be to hack NBD or AoE and
build a raid out of such devices.

Just ramblin' here.


-- 
Jon
