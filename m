From: Luca Berra <bluca@comedia.it>
Subject: Re: Please help with a special RAID 1 setup
Date: Wed, 07 Jan 2004 17:09:26 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FFC2F36.4000102@comedia.it>
References: <E5DA6395B8F9614EB7A784D628184B207E14CE@hdsmsx402.hd.intel.com> <3FFC26E1.8040706@interplus.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FFC26E1.8040706@interplus.ro>
To: Mircea Ciocan <mirceac@interplus.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mircea Ciocan wrote:
>    Ouch, so is there really no posibility to obtain somehow what I 
> explained in the previous mail ( a cvasi-realtime filesystem backup by 
> attaching and detaching a device) :(((
> Please tell me that there is a posibility, my world is shattered ;)
> 
use mdadm and recreate the array with 3 devices (using the missing 
keyword in place of the 3rd drive), then hotadd the new disk.

this operation does not destroy your data, but be sure to test it on a 
spare server until you are confident with the syntax

regards,
L.
