From: Linux Lists <user_linux@citma.cu>
Subject: Thanks to all of you
Date: Wed, 5 Feb 2003 17:54:34 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5E3B0C5C.5060806@citma.cu>
References: <5E39C7E9.3070306@citma.cu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I followed your advices and finally i got my promise sx6000 card working

Thank you very much

David

Linux Lists wrote:

>Here is the email answer I got back from Promise in october, attached are 
>the drivers I received.
>
> -- Mikael Abrahamsson email: swmike@swm.pp.se ---------- Forwarded 
> message ---------- Date: Mon, 21 Oct 2002 16:43:16 +0800 From: jackhu 
> <jackhu@promise.com> To: Mikael Abrahamsson <swmike@swm.pp.se> 
> Subject: Re: sx6000 with Redhat 7.3 and 8 Dear Sir: Check the Answer, 
> please.
>
>>>
>>> I have tried to get a fasttrack sx6000 to work with either redhat 7.3 or
>>> redhat 8.0 to no avail. The i2o driver gives just this:
>>>
>>> I2O Core - (C) Copyright 1999 Red Hat Software
>>> I2O: Event thread created as pid 18
>>> I2O Block Storage OSM v0.9
>>>    (c) Copyright 1999-2001 Red Hat Software.
>>> i2o_block: registered device at major 80
>>> i2o_block: Checking for Boot device...
>>> i2o_block: Checking for I2O Block devices...
>>>
>>> Then nothing happens. We have updated to the latest (77) firmware
>>> available on your webpage.
>>>
>>  
>>
>Answer:
>    Before you use I2O driver on RH7.3/8.0, you should set "OS Type" to be
>"NT". However, The Linux I2O driver doesn't drive sx600 card very well. I
>think you should use our scsi driver. But before you use our scsi driver,
>you should set "OS TYPE" in card's bios to be "LINUX".
>
>  
>
>>> I also tried to compile my own version from the GPLed source code you
>>> released. It compiles, but when trying to insert the module I get:
>>>
>>> ./pti_st.o: unresolved symbol kmalloc
>>> ./pti_st.o: unresolved symbol scsi_unregister_module
>>> ./pti_st.o: unresolved symbol pci_enable_device
>>> ./pti_st.o: unresolved symbol scsi_register
>>> ./pti_st.o: unresolved symbol unregister_blkdev
>>> ./pti_st.o: unresolved symbol pcibios_present
>>> ./pti_st.o: unresolved symbol free_irq
>>> ./pti_st.o: unresolved symbol register_blkdev
>>> ./pti_st.o: unresolved symbol iounmap
>>> ./pti_st.o: unresolved symbol __ioremap
>>> ./pti_st.o: unresolved symbol pci_read_config_word
>>> ./pti_st.o: unresolved symbol io_request_lock
>>> ./pti_st.o: unresolved symbol kfree
>>> ./pti_st.o: unresolved symbol pci_devices
>>> ./pti_st.o: unresolved symbol request_irq
>>> ./pti_st.o: unresolved symbol scsi_register_module
>>> ./pti_st.o: unresolved symbol pci_write_config_word
>>> ./pti_st.o: unresolved symbol sprintf
>>> ./pti_st.o: unresolved symbol printk
>>> ./pti_st.o: unresolved symbol scsi_unregister
>>> ./pti_st.o:
>>> Hint: You are trying to load a module without a GPL compatible license
>>>       and it has unresolved symbols.  Contact the module supplier for
>>>       assistance, only they can help you.
>>>
>>> I have tried several ways to get it to compile in other manners including
>>> like it's said in the readme file, but to no avail (as soon as I start
>>> changing the default makefile it wont compile at all).
>>>
>>> Please help. Also, please try to keep up to date with redhat when they're
>>> releasing new versions so owners of your equipment can continue using it.
>>>
>>  
>>
>Answer:
>    The unresolve messages are caused by you haven't set linux kernel source
>code correctly. You should do as what file readme.txt said. However, the
>source codes on website is little old, try the source codes attaching this
>email.
>    We have built sx6000 install package for RH7.3/RH8.0, but it's beta
>version, haven't release yet. But I think you can use it, if you are urgent.
>
>Best Regards.
>
>jack
>
>2002/10/21
>  
>


