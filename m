From: William Knop <wknop@andrew.cmu.edu>
Subject: Re: libata badness
Date: Mon, 4 Oct 2004 12:55:10 -0400 (EDT)
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60-041.0410041241540.9105@unix43.andrew.cmu.edu>
References: <Pine.LNX.4.60-041.0410040656001.2350@unix48.andrew.cmu.edu>
 <41617AA0.9020809@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <41617AA0.9020809@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids


> It either smells like a hardware problem or a raid problem.  The oops you 
> list here is in raid5 not libata.

I'm inclined to agree. I should have titled the thread "libata/md badness" 
since it appears to be a raid atop sata issue. Raid5 apparently works over 
scsi, though.

This is really beyond my realm of knowledge, though. After I check my 
drives for errors, I'm going to back up my array and then experiment a 
bit. I'll post any oopses I find in hopes that someone will be able to 
properly interpret them.

Will
