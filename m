From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: raid5: add prerequisite to run underneath dm-raid
Date: Mon, 9 May 2016 09:42:31 -0700
Message-ID: <20160509164231.GA11021@kernel.org>
References: <1462809009-2809-1-git-send-email-heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462809009-2809-1-git-send-email-heinzm@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: heinzm@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 09, 2016 at 05:50:09PM +0200, heinzm@redhat.com wrote:
> From: Heinz Mauelshagen <heinzm@redhat.com>
> 
> In case md runs underneath the dm-raid target, the mddev does not have
> a request queue or gendisk, thus avoid accesses.
> 
> This patch adds a missing conditional to the raid5 personality.

already added the 3 patches to my tree since you last post. I probably forgot
to reply you though, sorry.
