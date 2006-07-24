From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: In Trouble--Please Help! (was Re: Can't add disk to failed raid array)
Date: Mon, 24 Jul 2006 12:06:36 -0700
Message-ID: <e9c3a7c20607241206y3cab7c67sd08d78006fc51fb9@mail.gmail.com>
References: <200607152056.55090.pwaldo@waldoware.com>
	 <200607230753.47853.pwaldo@waldoware.com>
	 <17603.25777.274507.385333@cse.unsw.edu.au>
	 <200607230832.48807.pwaldo@waldoware.com>
	 <e9c3a7c20607241126n614b7941i4319a7889ac12c5e@mail.gmail.com>
	 <44C51300.6010002@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44C51300.6010002@waldoware.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Paul Waldo <pwaldo@waldoware.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I'll certainly give that a try later on, as I need physical access to
> the box.
>
> The corruption part is worrisome...  When you did this, did you
> experience corruption?  I'm running RAID6 with 7 disks; presumably even
> with two disks out of whack, I should be in good shape...???
>
I was running a 5 disk RAID-5 and did not detect any corruption.  Neil
correct me if I am wrong, but I believe that since your failure
occured without power loss that the chances for data corruption in
this case are small.

Dan
