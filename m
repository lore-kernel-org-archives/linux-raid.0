From: Alex Butcher <linraid@assursys.co.uk>
Subject: md check sync_action causes gnome-panel to grow at 1-3MB/s
Date: Thu, 27 Aug 2009 14:29:18 +0100 (BST)
Message-ID: <alpine.LFD.2.00.0908271421250.10020@sbhezbfg.of5.nffheflf.cev>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi -

I've filed a bug with GNOME at
<http://bugzilla.gnome.org/show_bug.cgi?id=592308> and added a comment to
the Red Hat Bugzilla for gnome-panel at
<https://bugzilla.redhat.com/show_bug.cgi?id=486764#c3>.

Essentially, if a particular user has a GNOME session running that includes
gnome-panel, and a md sync_action check on the array that hosts that user's
home directory is initiated, gnome-panel will allocate memory at a rate of
about 1-3MB/s until the check is complete.  I've tried reproducing the
problem with a clean user account but cannot.  It also occurs for the
original user even if all the GNOME config stuff is moved out of the way. 
Copying the SELinux context from the original to the clean user's home
directory still doesn't allow reproduction with the clean user's GNOME
session.

This suggests it's something magic about the original user's home directory,
combined with the sync_action check that's provoking this behaviour from
gnome-panel.

Any ideas on how I can proceed in attempting to get to the bottom of it?

The problem has been present with all Fedora 11 kernels I've tried, the latest
being 2.6.29.6-217.2.8.fc11.x86_64.

Thanks,
Alex
