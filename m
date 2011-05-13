From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm does not create partition devices whatsoever, "partitionable"
 functionality broken
Date: Fri, 13 May 2011 13:43:57 -0400
Message-ID: <4DCD6DDD.1090707@turmel.org>
References: <4DCD4A83.8060202@pulseforce.com> <4DCD6119.3080705@turmel.org> <4DCD67EF.1070602@pulseforce.com> <4DCD6B27.70402@pulseforce.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DCD6B27.70402@pulseforce.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher White <linux@pulseforce.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/13/2011 01:32 PM, Christopher White wrote:
> I forgot to mention that I've also tried "sudo fdisk /dev/md1" and creating two partitions that way. It fails too.

Please show "partx --show /dev/md1" after the fdisk operation above.

Phil
