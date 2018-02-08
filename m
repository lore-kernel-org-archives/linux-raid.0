From: Phil Turmel <philip@turmel.org>
Subject: Re: RFC - de-clustered raid 60 or 61 algorithm
Date: Thu, 8 Feb 2018 07:56:10 -0500
Message-ID: <e7c2c26c-c59b-ebab-423d-683a05ddfd8c@turmel.org>
References: <9f9e737c-d6d1-5cce-8190-14d970320265@youngman.org.uk>
 <876078maui.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <876078maui.fsf@notabene.neil.brown.name>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Wol's lists <antlists@youngman.org.uk>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/07/2018 10:14 PM, NeilBrown wrote:
> On Thu, Feb 08 2018, Wol's lists wrote:

>> I've been playing with a mirror setup, and if we have two mirrors, we 
>> can rebuild any failed disk by coping from two other drives. I think 
>> also (I haven't looked at it) that you could do a fast rebuild without 
>> impacting other users of the system too much provided you don't swamp 
>> i/o bandwidth, as half of the requests for data on the three drives 
>> being used for rebuilding could actually be satisfied from other drives.
> 
> I think that ends up being much the same result as a current raid10
> where the number of copies doesn't divide the number of devices.
> Reconstruction reads come from 2 different devices, and half the reads
> that would go to them now go elsewhere.

This begs the question:

Why not just use the raid10,near striping algorithm?  Say one wants
raid6 n=6 inside raid60 n=25.  Use the raid10,near6 n=25 striping
algorithm, but within each near6 inner stripe place data and P and Q
using the existing raid6 rotation.

What is the more complex placement algorithm providing?

Phil
