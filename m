From: Wols Lists <antlists@youngman.org.uk>
Subject: xosview - anybody willing to test it (the raid features :-)
Date: Thu, 4 Aug 2016 23:27:35 +0100
Message-ID: <57A3C157.100@youngman.org.uk>
References: <22435.38657.908865.828712@lrd.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22435.38657.908865.828712@lrd.home.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mike has pushed a test version to sourceforge and github. If anybody's
willing to clone the repository, compile and test that would be appreciated.

For those who don't know this utility, once you've built it just do
"xosview &" at the command line and you'll get a pretty little status
monitor appear on your screen.

I'm planning to test it tomorrow (wife permitting), so I'm not sure how
it's going to behave myself. As Mike says, all feedback will be welcome.

Cheers,
Wol


-------- Forwarded Message --------

  This may help.  I've turned the raid meter on by default and it is set to
auto which causes it to search for and display a meter for every md
device it
finds.  The meter gives a pretty compact overview of the raids current state
in one glance.

  If you are able to checkout and build a copy of the source from either of
these two repositories (I push to both) I'd be interested in your feedback.

https://sourceforge.net/p/xosview/git/ci/master/tree/

https://github.com/mromberg/xosview

  I developed the new raid meter code using a few of raid1 devices
(two drives per raid) with a fedora 24 setup running on a VM.   But I am not
an experienced raid administrator by any stretch of the imagination.   I
have
no doubt that there are cases and configurations I have not tested or
accounted
for.  So, I welcome any feedback on what is there so far.

Mike





