From: Asdo <asdo@shiftmail.org>
Subject: Re: Why do arrays start without some components?
Date: Mon, 15 Mar 2010 22:04:40 +0100
Message-ID: <4B9EA0E8.3020301@shiftmail.org>
References: <40b437201003151326t39be3b2hc3df6f79802b9b7e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <40b437201003151326t39be3b2hc3df6f79802b9b7e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Simon Matthews wrote:
> I have a couple of machines on which this is happening now --
>
> When the machine boots, the RAID arrays (RAID 1) start, but each array
> only has one component device. I can add the other component again
> (using mdadm --add ... ) and the array will sync up, but next time it
> boots, I have to do the same once more.
>
> Why is this and how do I fix it?
>   

Might that be a /etc/mdadm/mdadm.conf in the initramfs listing fewer 
devices than it should?
I am not sure (because in this case maybe it shouldn't autoassemble the 
array at all), but have a look by unpacking your initramfs. If yes, 
update it.
Or could that be a controller that shows the disks to the kernel too 
late... do you have multiple controllers?
