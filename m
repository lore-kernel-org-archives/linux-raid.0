From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: persistent removed MD referrence on reboot
Date: Wed, 01 Aug 2012 13:54:31 +1000
Message-ID: <5018A877.8020506@websitemanagers.com.au>
References: <CAO7BsSnu+CZMeQ=YNUKDOCQGF9FYjCTV37rhkBiW1JGAVexxuQ@mail.gmail.com> <50173458.40505@websitemanagers.com.au> <CAO7BsSnMTAWRjxFcq2AS1QGbudy82HVGYFTB395cKTdnfD2bVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO7BsSnMTAWRjxFcq2AS1QGbudy82HVGYFTB395cKTdnfD2bVw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Skip Coombe <skipcoombe@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/08/12 11:43, Skip Coombe wrote:
> Thanks for the quick response.
>
> I did "dd -if=/dev/zero -of=/dev/sdc" and modified the the partition to 83.
I've not seen this command line format, and not sure it is valid. I've
always used:

dd if=/dev/zero of=/dev/sdc

Also, can you confirm that this command completed successfully. If it
failed to zero to the end of the disk, then there may still be some
metadata available at the end of the disk.

Failing this, you would need to wait for someone else more knowledgeable
than me to comment.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
Ph: +61 2 8304 0000                            adam@websitemanagers.com.au
Fax: +61 2 8304 0001                            www.websitemanagers.com.au

