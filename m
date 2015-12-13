From: Phil Turmel <philip@turmel.org>
Subject: Re: Mdadm with data offsets
Date: Sun, 13 Dec 2015 18:56:34 -0500
Message-ID: <566E05B2.20803@turmel.org>
References: <CAH_hVdp4mGE-AZ1ww81u9vS0xri4xR+LrpaRSbaUb6VRohZ_Rg@mail.gmail.com>
 <566E0440.70801@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <566E0440.70801@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "TheGerwazy ." <gerardlesiuk@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/13/2015 06:50 PM, Phil Turmel wrote:
> On 12/13/2015 01:18 AM, TheGerwazy . wrote:
>> Hello
>> I have to recreate mdadm raid 6 made with different data offsets. Some
>> drives have 2048 and others 262144.
>> I am looking for mdadm version with data offsets option for each drive.
>> Could somebody help me. Please ?
> 
> version 3.3 and above, I believe.  If in doubt, just compile the latest
> version yourself -- no root privileges are required to compile it.  Then
> run it from the current directory.
> 
> git clone git://neil.brown.name/mdadm
> 
> make
> [sudo] ./mdadm ......

I should add that using --create to reconstruct an array is incredibly
dangerous (to your data) and should only be used as a last resort and
when you are 100% confident you know how to do it.  Your question
suggests that might not be true....  in which case sharing your problem
here might be wise.

Phil
