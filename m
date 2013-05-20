From: Sam Bingner <sam@bingner.com>
Subject: Re: Resync raid array problem
Date: Mon, 20 May 2013 03:43:54 +0000
Message-ID: <A1D0A2E7-ADA2-474A-BF8E-B60BBAA59D53@bingner.com>
References: <loom.20130520T035627-78@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20130520T035627-78@post.gmane.org>
Content-Language: en-US
Content-ID: <6345A29263B4054994657F52DD112DA5@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tarak <tarakramgopal@gmail.com>
Cc: "<linux-raid@vger.kernel.org>" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On May 19, 2013, at 3:57 PM, Tarak <tarakramgopal@gmail.com> wrote:

> Hi 
> We sucessfully created a Raid array of 8 harddisks.
> On power failure situation, the resync of raid array 
> is taking too much of time almost equal to 
> the time taken for creating the raid array of hard disks.
> Anyone is having an idea about this..
> Please help me on this.
> 
> Regards
> Tarak

If you enable a bitmap on the device it should significantly lower the resync times.... but of curse this should not be a normal occurrence, or you have bigger problems...

Sam

