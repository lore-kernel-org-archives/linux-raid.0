From: Neil Brown <neilb@suse.de>
Subject: Re: How to recover from massive disk failure
Date: Fri, 10 Nov 2006 11:54:24 +1100
Message-ID: <17747.52672.339031.967070@cse.unsw.edu.au>
References: <200611100150.39878.jacob@mungo.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jacob Schmidt Madsen on Friday November 10
Sender: linux-raid-owner@vger.kernel.org
To: Jacob Schmidt Madsen <jacob@mungo.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 10, jacob@mungo.dk wrote:
> # mdadm -As /dev/md5
> mdadm: /dev/md5 assembled from 2 drives - not enough to start the array.
> 
> No luck!
> 
> What can i do to get it up and running again?

Add a "--force" flag.

NeilBrown
