From: Weedy <weedy2887@gmail.com>
Subject: Re: raid5 messed up
Date: Fri, 8 Sep 2017 16:10:15 -0400
Message-ID: <3d9cfc15-e809-c3d2-831e-dae313101070@gmail.com>
References: <fdbb6bf6-357c-781e-beee-d8589cbb299d@email.latech.edu>
 <d08b6aaf-208e-f4bf-7d19-139103eb14cd@turmel.org>
 <42b3f75a-d93d-f20d-579b-901a305fb508@email.latech.edu>
 <59B09036.1040600@youngman.org.uk>
 <6e5083a4-609b-daba-3326-0dbd9dda6c34@email.latech.edu>
 <59B165ED.406@youngman.org.uk>
 <7f4bfb83-cb9c-aa50-5cb7-23cfd7da3e45@email.latech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7f4bfb83-cb9c-aa50-5cb7-23cfd7da3e45@email.latech.edu>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: bishop@latech.edu, Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/09/17 11:40 AM, Thomas C. Bishop wrote:
> I have servers configured w/ HW controlled raid and have had virtually
> NO problems w/ those. Both my backup machines are SW raid... I've had to
> replace multiple drives on the SW configured raid. The drives are either
> SAME MODEL or same Seagate drive family in all cases and one server is
> actually the same SuperMicro model as one of the desktops.
> 
> I had attributed this to just a hotter running environment.. the backup
> machines are desktop workstations w/ NVIDIA graphics cards that run
> pretty hot, but I'm rethinking this now.
> 
> Any chance SW raid is running the HDs harder/hotter than the HW raid? 
> All machines run 24-7-365 so power cycling is not the issue and the
> server room is not necessarily cooler than the office/desktop environment.
> 
> Tom

I would argue software raid is going to run your drives harder then a
battery backed raid card.

The cards DRAM buffer will probably shift a large majority of writes to
full stripe writes. Vs. if you do anything with files smaller then
stripe basically EVERYTHING is going to be a read-modify-write on md raid5.

All that said, is it going to be enough of a workload delta to see
lifetime differences? That's going to depend on your workload. I have
quite an old array and my drives seem to not care so... YMMV.

# for drive in sda sdb sdc sdd sde sdf sdg sdh; do smartctl --all
/dev/$drive|grep Power_On_Hours; done
  9 Power_On_Hours          0x0032   027   027   000    Old_age   Always
      -       64114
  9 Power_On_Hours          0x0032   035   035   000    Old_age   Always
      -       57735

## the raid5 ##
  9 Power_On_Hours          0x0032   090   090   000    Old_age   Always
      -       49785
  9 Power_On_Hours          0x0032   022   022   000    Old_age   Always
      -       57543
  9 Power_On_Hours          0x0032   084   084   000    Old_age   Always
      -       80950
  9 Power_On_Hours          0x0032   022   022   000    Old_age   Always
      -       57364


  9 Power_On_Hours          0x0032   098   098   000    Old_age   Always
      -       1078
  9 Power_On_Hours          0x0032   098   098   000    Old_age   Always
      -       1079
