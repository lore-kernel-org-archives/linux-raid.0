From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raidtools vs mdadm
Date: Tue, 31 Aug 2004 15:27:38 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408311927.i7VJRi311085@watkins-home.com>
References: <1093978543.3399.20.camel@rich>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1093978543.3399.20.camel@rich>
To: 'rich turner' <rich@storix.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

As I understand it, raidtools is not supported anymore.  The gods of RAID
support mdadm.  I get this info from this list.

RedHat 9 still uses raidtools.  I don't know about the newer versions of
redhat.  RedHat, you there?  Please use mdadm!  I don't know what other
distributions use.  I plan to give Debian a try the next time I setup a
system.

People have posted patches to remove raidstart from the startup scripts, and
replace them with mdadm.

I use mdadm, it is much better at starting arrays with issues, and
correcting them.  However I still use the stock scripts during re-boot which
still use raidstart.

I think raidtools has 1 item that mdadm does not.  That is raidreconf.
Mdadm does not support that function.  Correct me if I am wrong!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of rich turner
Sent: Tuesday, August 31, 2004 2:56 PM
To: linux-raid@vger.kernel.org
Subject: raidtools vs mdadm

i work for a software company that develops backup and disaster recovery
software for linux. our product supports software raid, but i must say
that we currently only support it when devices are created with
raidtools. i only recently heard about mdadm and am very impressed with
its flexibility and funtionality.

my question is how popular is mdadm in production environments as this
compares to raidtools?

is mdadm used to configure software raid on any distribution
installations?

is mdadm trending to become the defacto standard for software raid on
linux?

rich turner

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

