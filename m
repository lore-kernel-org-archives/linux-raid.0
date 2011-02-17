From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID5 won't mount after reducing disks from 8 to 6
Date: Wed, 16 Feb 2011 21:13:48 -0500
Message-ID: <4D5C845C.7080302@turmel.org>
References: <C2D86BF5-AECE-49B3-B139-1CD6375DCFC9@mac.com> <4D5C7A33.90007@turmel.org> <49F0C863-F2E0-46FD-883C-D4D458CA4A4E@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F0C863-F2E0-46FD-883C-D4D458CA4A4E@mac.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Tehonica <matt.tehonica@mac.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/16/2011 08:39 PM, Matt Tehonica wrote:
> Thanks for the response!  All I did was truncate the array using "mdadm --grow /dev/md0 --array-size" and then resize the array using "mdadm --grow /dev/md0 --raid-devices=6" so I guess I didn't resize the XFS FS first.  Is that something I can do now or am I screwed?

Ouch.  I don't know if you are screwed.  Unless you wrote to it, in which case you probably are.  But you haven't been able to mount it, I presume, so you might be OK.  It depends on whether the reshape is reversible.  If it's not reversible, you'll have to ask the XFS experts xfs@oss.sgi.com or linux-xfs@vger.kernel.org

Neil?
