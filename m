From: Philip Molter <philip@corp.texas.net>
Subject: Re: Force parity resync on raid5?
Date: Tue, 10 Aug 2004 22:37:06 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41199462.9050408@corp.texas.net>
References: <4118B9A8.2040102@corp.texas.net>	<16664.49686.253255.828936@cse.unsw.edu.au>	<4118DBFA.6020607@corp.texas.net> <16665.33845.170965.226004@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16665.33845.170965.226004@cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> However I have just release mdadm 1.7.0 which supports
>    --assemble --update=resync
> 
> which will cause an array to resync immediately after being
> assembling.  This don't help you for an array with a root filesystem
> on it, but should do want you want for any other array.

Neil,

Thank you.  I'll let you know if we have any problems with the resyncing.

Philip
