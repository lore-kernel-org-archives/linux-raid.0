From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID10 failure(s)
Date: Mon, 14 Feb 2011 16:29:03 -0600
Message-ID: <4D59ACAF.9020703@hardwarefreak.com>
References: <AANLkTimqZqjJuwmC+zX3Uyx_xrWC0i07y5idrnaQXyWF@mail.gmail.com> <AANLkTinfaYYcq1++_vx0nNMDftiv9Eqg_eDR2Q0QfoS7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinfaYYcq1++_vx0nNMDftiv9Eqg_eDR2Q0QfoS7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Keisler <grimm26@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Keisler put forth on 2/14/2011 2:33 PM:

> Still wondering if there is some magic to be done to get at my data again :)
>>
>> Am I totally SOL?  Thanks for any suggestions or things to try.
>>
>> --
>> Mark
>> Tact is the ability to tell a man he has an open mind when he has a
>> hole in his head.

Interesting, and ironically appropriate, sig, Mark.

No magic is required.  Simply wipe each disk by writing all zeros with dd.  You
can do all 4 in parallel.  This will take a while with 1TB drives.  If there are
still SATA/NCQ/etc issues they should pop up while wiping the drives.  If not,
and all dd operations complete successfully, simply create a new RAID 10 array
and format it with your favorite filesystem.

Then restore all your files from your backups.[1]

[1] Tact is the ability to tell a man he has an open mind when he has a hole in
his head.

-- 
Stan
