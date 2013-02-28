From: Drew <drew.kay@gmail.com>
Subject: Re: Rocketraid 640 raid 5 disabled
Date: Wed, 27 Feb 2013 19:52:55 -0800
Message-ID: <CACJz6QvecsLtH+uPzZrbniv1z_UAqha6xOwSiR8RcK851Aoscw@mail.gmail.com>
References: <CAHijsZvKW0A5CWj01X7wp3fDfh9S0RtORnaVZYyE8McsLJLSAQ@mail.gmail.com>
 <512DAA12.3000700@hardwarefreak.com> <CAHijsZtnGHWwM4oozxRY7GcAiMBM2H-+xYm9CnvCneeM9WcDAQ@mail.gmail.com>
 <CACJz6Qvd1QEC3bQFiZLAS4A+wNMNL5fW-G_Gmf2mydem=0mroQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACJz6Qvd1QEC3bQFiZLAS4A+wNMNL5fW-G_Gmf2mydem=0mroQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Khurram Hassan <kfhassan@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Feb 27, 2013 at 7:28 PM, Drew <drew.kay@gmail.com> wrote:
>> I would like to use mdadm to re-write the array's metadata so that the
>> disks are accessible again. I have done it previously also but with an
>> intel array and loads of help from Neil Brown. I am hoping he can work
>> his magic again :)
>
> You probably won't be able to. The Intel RAID controllers were
> possible because developers from Intel frequent this list and have
> assisted in the efforts to get IMSM RAID supported by mdadm. The RAID
> metadata from other controllers like Adaptec or LSI are usually
> proprietary and afaik, are not supported by mdadm.

Looking at the linux source closer for the hpt driver, I'm thinking
it's proprietary. There are several pre-compiled object files that
appear to contain the driver code for the various RAID related
functions. That also suggests the controller is a fakeraid controller,
a HPT trademark, especially given the price point locally.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
