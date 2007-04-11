From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: [PATCH RFC 3/4] md: writeback caching policy for raid5 [experimental]
Date: Wed, 11 Apr 2007 18:40:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0704111837410.5557@coffee.psychology.mcmaster.ca>
References: <20070411055729.15745.51513.stgit@dwillia2-linux.ch.intel.com>
 <20070411060036.15745.7016.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070411060036.15745.7016.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> In its current implementation write-back mode acknowledges writes before
> they have reached non-volatile media.

which is basically normal for unix, no?

are you planning to support barriers?  (which are the block system's way 
of supporting filesystem atomicity).
