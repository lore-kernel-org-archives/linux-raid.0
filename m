From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/3] lib/raid6: update test program recovery functions
Date: Sat, 17 Mar 2012 18:05:39 -0700
Message-ID: <4F6534E3.5000200@zytor.com>
References: <1331939167-10787-1-git-send-email-james.t.kukunas@linux.intel.com> <1331939167-10787-3-git-send-email-james.t.kukunas@linux.intel.com> <1331974344.3602.4.camel@mattotaupa> <20120318002941.GA12405@jtkukuna_gentoo_sb.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120318002941.GA12405@jtkukuna_gentoo_sb.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: Paul Menzel <pm.debian@googlemail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/17/2012 05:29 PM, Jim Kukunas wrote:
> 
> The reason for this change is that <linux/module.h> drags in headers which
> are not visible to userspace, thus breaking the build for the test program.
> 
> You are correct, it should be mentioned in the commit message.
> 

Sounds like it should be a separate commit, at the head of the series.

	-hpa

