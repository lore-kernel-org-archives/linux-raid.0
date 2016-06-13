From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/1] MD:Update superblock when err == 0 in size_store
Date: Mon, 13 Jun 2016 11:47:05 -0700
Message-ID: <20160613184705.GA20136@kernel.org>
References: <1465723080-9375-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465723080-9375-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jun 12, 2016 at 05:18:00PM +0800, Xiao Ni wrote:
> Hi
> 
> This is a simple check before updating the superblock. It should update
> the superblock when update_size return 0.

Applied, thanks!
